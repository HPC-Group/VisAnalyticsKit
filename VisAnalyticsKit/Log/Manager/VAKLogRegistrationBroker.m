//
//  VAKStateLoggerManager+Config.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 28.01.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//
// This was inspired the "DSL Category" of https://github.com/orta/ARAnalytics

// Custom
#import "VAKLogRegistrationBroker.h"
#import "NSObject+VAKAspect.h"

// --

typedef void (^DefaultInterceptionBlock)(id<AspectInfo> aspectInfo);

// --
// \cond HIDDEN_SYMBOLS
@interface VAKLogRegistrationBroker()

@property(readwrite, nonatomic) NSMutableOrderedSet<id<AspectToken>> *interceptors;
@property(readwrite, nonatomic) VAKLogManager *manager;

@end
// \endcond

// --

@implementation VAKLogRegistrationBroker

- (instancetype)init {
    if (self = [super init]) {
        _interceptors = [[NSMutableOrderedSet alloc] init];
        _manager = [VAKLogManager sharedLogManager];
        
        return self;
    }
    
    return nil;
}

- (void)configureWithDictionary:(NSDictionary *)configDictionary {
    [self enumerateDictionary:configDictionary[kVAKConfigViews]];
    [self enumerateDictionary:configDictionary[kVAKConfigEvents]];
}

/**
 *  helper to keep things dry
 *  SIDEEFFECTS: registers given interceptors
 *
 *  @param NSArray configArray  either the views or the events dictionary to configure method interception
 */
- (void)enumerateDictionary:(NSArray *)configArray {
    [configArray enumerateObjectsUsingBlock:^(NSDictionary *confDictionary, NSUInteger idx, BOOL *stop) {
        id theClass = confDictionary[kVAKConfigClass];
        
        if ([theClass isKindOfClass:NSString.class]) {
            theClass = NSClassFromString(confDictionary[kVAKConfigClass]);
        }
        
        [self registerInterceptor:theClass context:confDictionary[kVAKConfigClassContext]];
    }];
}

- (void)unregisterInterceptors {
    [_interceptors enumerateObjectsUsingBlock:^(id _Nonnull aspectToken, NSUInteger idx, BOOL * _Nonnull stop) {
        [aspectToken remove];
    }];
    [_interceptors removeAllObjects];
}

#pragma mark Helper

/**
 *  helper to more or less call the execute hook method recursively
 *
 *  @param Class theClass the class that's parent to a given selector
 *  @param NSArray|NSDictionary context can be a list of dictionaries or a single dictionary
 */
- (void)registerInterceptor:(id)theClass context:(id)context {
    __block id<AspectToken> aspectToken;
    
    if ([context isKindOfClass:NSArray.class]) {
        [context enumerateObjectsUsingBlock:^(NSDictionary *innerContext, NSUInteger index, BOOL *innerStop) {
            aspectToken = [self registerHook:theClass withContext:innerContext];
            
            if (aspectToken) {
                [_interceptors addObject:aspectToken];
            }
        }];
        
    } else {
        aspectToken = [self registerHook:theClass withContext:context];
        
        if (aspectToken) {
            [_interceptors addObject:aspectToken];
        }
    }
}

/**
 *  helper to log all hook related state
 *
 *  @param Class contextClass the class that's parent to a given selector
 *  @param NSDictionary context the context dictionary specific to a hook
 */
- (id<AspectToken>)registerHook:(id)contextClass withContext:(NSDictionary *)context {
    id<AspectToken> aspectToken;
    VAKInterceptionPoint interceptionPosition = context[kVAKConfigIntercept] ?
            (VAKInterceptionPoint) [context[kVAKConfigIntercept] integerValue] : VAKInterceptAfter;
    SEL selector = NSSelectorFromString(context[kVAKConfigSelector]);
    
    BOOL instanceResponds = [contextClass respondsToSelector:selector];
    // generally it's discouraged to use the class getter
    // but in this case it's the only way to make it work as expected
    BOOL classResponds = [[contextClass class] instancesRespondToSelector:selector];
    
    if (!instanceResponds && !classResponds) {
        NSLog(@"--- VAKError - Class %@ doesn't recognize selector: %@", contextClass, context[kVAKConfigSelector]);
        return nil;
    }
    
    if (!context[kVAKConfigInterceptionBlock]) {
        aspectToken = [contextClass vak_intercept:selector
            withOptions:interceptionPosition
            usingBlock:^(id<AspectInfo> aspectInfo) {
                NSMutableDictionary<NSString *, id> *stateDict = [[NSMutableDictionary alloc] init];
                
                if (context[kVAKConfigLogLevel]) {
                    stateDict[kVAKStateLogLevel] = context[kVAKConfigLogLevel];
                }
                
                if (context[kVAKConfigTags]) {
                    stateDict[kVAKStateTags] = context[kVAKConfigTags];
                }
                
                if (context[kVAKConfigComment]) {
                    stateDict[kVAKStateComment] = context[kVAKStateComment];
                }
                
                if (aspectInfo.arguments != nil) {
                    // this can lead to bugs!
                    // TODO: check indices of arguments and transform them accordingly
                    stateDict[kVAKStateData] = aspectInfo.arguments;
                }

                if (context[kVAKStateIDAttribute]) {
                    stateDict[kVAKStateIDAttribute] = context[kVAKStateIDAttribute];
                }

                // provenance
                stateDict[kVAKStateCauser] = @{
                    kVAKCallerName:NSStringFromClass(contextClass),
                    kVAKMethodCalled:context[kVAKConfigSelector]
                };
                
                VAK_RECORD_DICT(stateDict);
                
        }
        error:nil];
        
    } else {
        aspectToken = [contextClass vak_intercept:selector
            withOptions:interceptionPosition
            usingBlock:context[kVAKConfigInterceptionBlock]
            error:nil
        ];
    }
    
    return aspectToken;
}

@end
