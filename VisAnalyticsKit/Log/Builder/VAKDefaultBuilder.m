//
//  VAKDefaultBuilder.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 17.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

// Custom
#import <VisAnalyticsKit/VisAnalyticsKit.h>
#import "VAKAppSupportFileWriter.h"
#import "VAKAppSupportFileReader.h"

#if defined(TARGET_OS_IPHONE) || defined(TARGET_IPHONE_SIMULATOR)
#import <UIKit/UIKit.h>
#endif

// --
// \cond HIDDEN_SYMBOLS
@interface VAKDefaultBuilder ()

@property(readwrite) VAKLogManager *manager;
@property(readwrite) NSArray<NSString *> *consoleFieldsWhitelist;
@property(readwrite) NSArray<NSString *> *consoleTagsBlacklist;

@end
// \endcond

#pragma mark public

@implementation VAKDefaultBuilder

- (VAKLogManager *)build:(NSDictionary *)config {
    _manager = [VAKLogManager sharedLogManager];
    
    [self mergeWithDefaultConfig:config];
    
    if (config[kVAKConfigConsoleFieldsWhitelist]) {
        _consoleFieldsWhitelist = config[kVAKConfigConsoleFieldsWhitelist];
    }

    if (config[kVAKConfigConsoleTagsBlacklist]) {
        _consoleTagsBlacklist = config[kVAKConfigConsoleTagsBlacklist];
    }

    [self addBackends];
    [self setClient];
    [self registerSessionLifeCycle];

    return [self build];
}

- (VAKLogManager *)build {
    VAKLogRegistrationBroker *broker = [[VAKLogRegistrationBroker alloc] init];
    [broker configureWithDictionary:_config];
    
    return _manager;
}

#pragma mark Helpers to keep stuff readable

/**
 * pushes
 */
- (void)addBackends {
    id backendsToUse = [self useBackends];
    [self addCustomBackends];
    
    if ([backendsToUse respondsToSelector:@selector(enumerateObjectsUsingBlock:)]) {
        [backendsToUse enumerateObjectsUsingBlock:^(id _Nonnull backendType, NSUInteger idx, BOOL * _Nonnull stop) {
            VAKBackend *backend = [self addConfiguredBackend:(VAKBackendTypes) [backendType integerValue]];
            [_manager registerBackend:backend];
        }];
        
    } else if (backendsToUse) {
        // a single backend has been set
        [_manager registerBackend:[self addConfiguredBackend:(VAKBackendTypes) [backendsToUse integerValue]]];
        
    } else if (![_manager hasBackends]) {
        VAKConsoleProvider *provider = [[VAKConsoleProvider alloc] init];
        provider.fieldsWhitelist = _consoleFieldsWhitelist;
        provider.tagsBlacklist = _consoleTagsBlacklist;
        
        // no backends at all :( , so set one.
        id<VAKBackendProtocol> noopConsoleBackend = [VAKBackend createWithComponents:VAKBackendConsoleNoop
            name:kVAKBackendConsoleNoopName
            provider:provider
            dispatcher:[VAKNoopDispatcher sharedNoopDispatcher]];
        [_manager registerBackend:noopConsoleBackend];
    }
}

/**
 *  helper to set the clientInformation: namely appName and appVersion
 *  SIDEEFFECTS: sets the clientInfo of the manager
 */
- (void)setClient {
    if (_config[kVAKConfigClient]) {
        NSMutableDictionary *clientInfo = [[NSMutableDictionary alloc] init];

        // flatten client info!
        // otherwise prov info will definitely fail to validate
        [_config[kVAKConfigClient] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (!clientInfo[key]) {
              clientInfo[key] = obj;
            }
      }];

      _manager.clientInfo = clientInfo;
    }
}

- (void)registerSessionLifeCycle {
    if (!_config[kVAKConfigRegisterSessionLifecycle]){
        return;
    }

#if defined(TARGET_OS_IPHONE) || defined(TARGET_IPHONE_SIMULATOR)
    Class appDelegateClass = NSClassFromString(_config[kVAKConfigRegisterSessionLifecycle]);

    SEL willResign = @selector(applicationWillResignActive:);
    SEL enterBackground = @selector(applicationDidEnterBackground:);
    SEL willTerminate = @selector(applicationWillTerminate:);
    SEL enterForeground = @selector(applicationWillEnterForeground:);
    SEL becomeActive = @selector(applicationDidBecomeActive:);

    // - TERMINATION

    [appDelegateClass vak_intercept:willResign
                        withOptions:VAKInterceptAfter
                         usingBlock:^(id <AspectInfo> aspectInfo) {
                             VAK_RECORD_DICT((@{
                                     kVAKStateTags:@[kVAKTagsEvents, @"life-cycle"],
                                     kVAKStateComment: @"applicationWillResignActive",
                                     kVAKStateCauser:@{
                                             kVAKCallerName:kVAKConfigRegisterSessionLifecycle,
                                             kVAKMethodCalled:@"applicationWillResignActive:"
                                     }
                             }));
                             } error:nil];

    [appDelegateClass vak_intercept:enterBackground
                        withOptions:VAKInterceptAfter
                         usingBlock:^(id <AspectInfo> aspectInfo) {
                             VAK_RECORD_DICT((@{
                                     kVAKStateTags:@[kVAKTagsEvents, @"life-cycle"],
                                     kVAKStateComment: @"applicationDidEnterBackground",
                                     kVAKStateCauser:@{
                                             kVAKCallerName:_config[kVAKConfigRegisterSessionLifecycle],
                                             kVAKMethodCalled:@"applicationDidEnterBackground:"
                                     }
                             }));

                           // deregister observer
                           [[NSNotificationCenter defaultCenter] removeObserver:self];
                            if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
                                [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
                            }

                            VAK_CLOSE_SESSION();

                         } error:nil];


    [appDelegateClass vak_intercept:willTerminate
                        withOptions:VAKInterceptBefore
                         usingBlock:^(id <AspectInfo> aspectInfo) {
                             VAK_CLOSE_SESSION();
                         } error:nil];

    // - ACTIVATION

    [appDelegateClass vak_intercept:enterForeground
                        withOptions:VAKInterceptAfter
                         usingBlock:^(id <AspectInfo> aspectInfo) {
                            VAK_START_SESSION();
                             VAK_RECORD_DICT((@{
                                     kVAKStateTags:@[kVAKTagsEvents, @"life-cycle"],
                                     kVAKStateComment: @"applicationWillEnterForeground:",
                                     kVAKStateCauser:@{
                                             kVAKCallerName:_config[kVAKConfigRegisterSessionLifecycle],
                                             kVAKMethodCalled:@"applicationWillEnterForeground:"
                                     }
                             }));
                         } error:nil];


    [appDelegateClass vak_intercept:becomeActive
                           withOptions:VAKInterceptAfter
                            usingBlock:^(id<AspectInfo> aspectInfo) {
                                NSLog(@"applicationDidBecomeActive:");
                            } error:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
#endif
}

- (void)orientationChanged:(NSNotification *)note {
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];

    // Ignore changes in device orientation if unknown, face up, or face down.
    if (!UIDeviceOrientationIsValidInterfaceOrientation(currentOrientation)) {
        return;
    }

    VAK_RECORD_DICT((@{
      kVAKStateTags:@[kVAKTagsEvents, kVAKTagsUI, @"hardware", @"orientation-changed", kVAKTagsKeyframe],
      kVAKStateComment:@"Orientation changed",
      kVAKStateData:@(currentOrientation)
    }));
}

/**
 *  helper function to easily add pre-configured backends.
 *  uses a strategy pattern.
 *
 *  @param VAKBackendTypes an unsigned integer that dictates which provider to choose
 *
 *  @return id<VAKBackendProtocol> a usable backend
 */
- (id<VAKBackendProtocol>)addConfiguredBackend:(VAKBackendTypes)type {
    id<VAKPersistenceProviderProtocol> provider;
    id<VAKRemoteDispatchProtocol> dispatcher;
    NSString *name;
    
    VAKConsoleProvider *consoleProvider;
    
    switch (type) {
        case VAKBackendNSLogNoop:
            consoleProvider = [[VAKNSLogProvider alloc] init];
            consoleProvider.fieldsWhitelist = _consoleFieldsWhitelist;
            consoleProvider.tagsBlacklist = _consoleTagsBlacklist;
            
            dispatcher = [VAKNoopDispatcher sharedNoopDispatcher];
            name = kVAKBackendNSLogNoopName;
            provider = consoleProvider;
            
            break;
            
        case VAKBackendJsonNoop:
            provider = [VAKJsonFileProvider createWithIOComponents:[VAKAppSupportFileWriter create]
                reader:[[VAKAppSupportFileReader alloc] init]
                folder:nil
            ];
            dispatcher = [VAKNoopDispatcher sharedNoopDispatcher];
            name = kVAKBackendJsonNoopName;
            break;
            
        default:
            //VAKPersistenceProviderConsole:
            consoleProvider = [[VAKConsoleProvider alloc] init];
            consoleProvider.fieldsWhitelist = _consoleFieldsWhitelist;
            consoleProvider.tagsBlacklist = _consoleTagsBlacklist;
            
            dispatcher = [VAKNoopDispatcher sharedNoopDispatcher];
            name = kVAKBackendConsoleNoopName;
            provider = consoleProvider;
            break;
    }
    
    return [VAKBackend createWithComponents:type name:name provider:provider dispatcher:dispatcher];
}

/**
 *  helper to add custom backends 
 *  SIDEEFFECTS: adds configured backends to the list of backends to be used
 */
- (void)addCustomBackends {
    id customBackends = _config[kVAKConfigCustomBackends];

    if (!customBackends) {
        return;
    }
    
    if ([customBackends isKindOfClass:NSArray.class]) {
        [customBackends enumerateObjectsUsingBlock:^(id  _Nonnull backend, NSUInteger idx, BOOL * _Nonnull stop) {
            [_manager registerBackend:backend];
        }];
        
    } else if ([customBackends conformsToProtocol:@protocol(VAKBackendProtocol)]) {
        [_manager registerBackend:customBackends];
    }
}

/**
 *  helper function to merge custom and default configuration
 *  SIDEEFFECTS: sets _config property
 *
 *  @param NSDictionary config the custom configuration
 */
- (void)mergeWithDefaultConfig:(NSDictionary<NSString *, id> *)config {
    NSDictionary<NSString *, id> *defaults = @{ kVAKConfigDatabaseName: kVAKConfigDefaultDatabaseName };
    
    NSMutableDictionary<NSString *, id> *mergedConfigs = [NSMutableDictionary dictionaryWithDictionary:defaults];
    [mergedConfigs addEntriesFromDictionary:config];
    
    _config = mergedConfigs;
}

/**
 *  checks if the configuration has defined backends to be used
 *
 *  @return NULL|VAKBackendTypes|VAKBackendTypes[] if defined
 */
- (id)useBackends {
    id backendsToUse;
    
    if (_config[kVAKConfigWhichBackends]) {
        backendsToUse = _config[kVAKConfigWhichBackends];
    }
    
    return backendsToUse;
}


@end
