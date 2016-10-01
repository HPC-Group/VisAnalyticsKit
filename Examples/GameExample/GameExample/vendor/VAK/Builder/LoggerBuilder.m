//
//  LoggerBuilder.m


#import <sys/utsname.h>

// Custom
#import "LoggerBuilder.h"
#import "CouchbaseLiteDispatcher.h"
#import "CouchbaseLiteProvider.h"

/**
 *  returns system information that identify a device
 *  taken from http://stackoverflow.com/a/11197770/406801
 *
 *  @return NSString
 */
static NSString *deviceName() {
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

static NSString *gatewayUrl = @"http://vak.telemetry.dev:4984/sync_gateway";

// ---------------------
#pragma mark Builder Impl
// ---------------------

@implementation LoggerBuilder

+ (VAKLogManager *)createAndBuild {
    return [[[LoggerBuilder alloc] init] build];
}

// -

/**
 * configures the logManager
 * registers backends
 * registers views and events to track
 */
- (VAKLogManager *)build {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    VAKDefaultBuilder *builder = [[VAKDefaultBuilder alloc] init];
    
    NSDictionary<NSString *, id> *config = @{
      kVAKConfigWhichBackends:@[
        @(VAKBackendConsoleNoop),
        @(VAKBackendJsonNoop)
      ],
      kVAKConfigClient:@{
        kVAKConfigClientName:infoDictionary[@"CFBundleName"],
        kVAKConfigClientBuild:infoDictionary[@"CFBundleIdentifier"],
        kVAKConfigClientVersion:infoDictionary[@"CFBundleShortVersionString"],
        kVAKConfigClientBuild:infoDictionary[@"CFBundleVersion"],
        kVAKConfigClientId:@"game-example-unique-id",
        kVAKConfigClientDeviceType:deviceName(),
      },
      kVAKConfigCustomBackends:[self couchbaseBackend],
      kVAKConfigViews:[self views],
      kVAKConfigEvents:[self events],
      kVAKConfigRegisterSessionLifecycle:@"AppDelegate",
      kVAKConfigConsoleFieldsWhitelist:@[
        kVAKStateTimestamp,
        kVAKStateTags,
        kVAKSessionStart, kVAKSessionEnd,
        kVAKStateComment
      ],
      kVAKConfigConsoleTagsBlacklist:@[
          // To prevent Touches to show up on console output
          kVAKTagsTouches
        ]
    };
    
    VAKLogManager *manager = [builder build:config];
    [manager startSession];
    [manager push];

    return manager;
}

/**
 * the couchbase backend configuration
 */
- (VAKBackend *)couchbaseBackend {
    NSString *dbName = @"dbname"; // Needs to be lower case

    CouchbaseLiteProvider *provider = [CouchbaseLiteProvider createWithName:dbName];
    [provider createViews];

    return [VAKCustomBackend
      createWithComponents:@"Couchbase Database"
                  provider:provider
                dispatcher:[CouchbaseLiteDispatcher createWithDictionary:@{
                  kVAKConfigDatabaseName:dbName,
                  kVAKConfigUsername:kVAKConfigDefaultUsername,
                  kVAKConfigUserPassword:kVAKConfigDefaultUserPassword,
                  kVAKConfigRemoteAddress:gatewayUrl
        }]
    ];
}

/**
 * views to track
 */
- (NSArray<NSDictionary<NSString *, id> *> *)views {
    NSArray *viewTags = @[kVAKTagsViews];
    NSString *viewWillAppearSelector = @"viewWillAppear:";
    NSString *viewAttribute = @"v";

    return @[
    @{
      kVAKConfigClass:@"GameViewController",
      kVAKConfigClassContext:@{
        kVAKConfigSelector:viewWillAppearSelector,
        kVAKConfigTags:viewTags,
        kVAKConfigComment:@"Loaded VolumeView",
        kVAKStateIDAttribute:viewAttribute,
      }
    }];
}

/**
 * events to track
 */
- (NSArray<NSDictionary<NSString *, id> *> *)events {
    NSMutableArray<NSDictionary *> *eventCatcher = [[NSMutableArray alloc] init];
    [eventCatcher addObject:[self touchEvents]];
    return eventCatcher;
}


- (NSDictionary<NSString *, id> *)touchEvents {
    __block VAKTouchCollection *touchCollection;
    __block VAKState *state;
    __block NSTimeInterval firstTouchTimestamp;

    void (^addTouchesBlock)(NSSet<UITouch *> *touches);
    addTouchesBlock = ^(NSSet<UITouch *> *touches) {
#if (VAK_LOG_ON == 1)
        NSMutableArray *innerTouches = [[NSMutableArray alloc] init];

        // The following might be the reason why it's kind of unsmooth to
        // transform a volume
        for (UITouch *touch in touches) {

          // first of all check if the touches passed in just began.
          // there are multiple touch instances in the set, so
          // only init the touchCollection
          if (touch.phase == UITouchPhaseBegan && !touchCollection) {
            state = [VAKState vak_createWithDictionary:@{
              kVAKStateTags:@[kVAKTagsTouches],
              kVAKStateComment:@"Touch events"
            }];
          
            if (touch.view) {
              state.causer = @{kVAKCallerName:NSStringFromClass(touch.view.class)};
            }
          
            firstTouchTimestamp = touch.timestamp;
            touchCollection = [VAKTouchCollection open];
          }
          [innerTouches addObject:[touch vak_objectAsDictionary]];
        }

        [touchCollection addTouches:innerTouches];

        // check if we can close this touch collection
        for (UITouch *touch in touches) {
          BOOL isCanceled = touch.phase == UITouchPhaseCancelled;
          BOOL hasEnded = touch.phase == UITouchPhaseEnded;

          if ((hasEnded || isCanceled) && touchCollection) {
            state.specialIDAttribute = @"t";
            state.data = @{
                @"touches":[touchCollection getTouches],
                @"approxDuration":@(touch.timestamp - firstTouchTimestamp)
            };

            VAK_RECORD(state);

            touchCollection = nil;
            state = nil;
            firstTouchTimestamp = 0;

            return;
        }
      }
#endif
    };

    void (^eventBlock)(id<AspectInfo> aspectInfo, UIEvent *event);
    eventBlock = ^(id<AspectInfo> aspectInfo, UIEvent *event) {
      switch (event.type) {
        case UIEventTypeMotion:
          NSLog(@"motion event");
        break;

        case UIEventTypeTouches:
         addTouchesBlock([event allTouches]);
        break;

        case UIEventTypePresses:
          NSLog(@"press type event");
        break;

        case UIEventTypeRemoteControl:
          NSLog(@"event: remoteControl");
        break;

        default:
            NSLog(@"undisclosed event: %@", event);
        break;
      }
    };
    
    // this is the lowest point that will later on
    // broadcast the event to the specific responder
    // it's a good idea do intercept this selector
    // because we are now able to catch Touch/Motion events
    // really easily
    return @{
      kVAKConfigClass:@"UIApplication",
      kVAKConfigClassContext:@{
        kVAKConfigSelector:@"sendEvent:",
        kVAKConfigInterceptionBlock:eventBlock
      }
    };
}

@end
