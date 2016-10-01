//
//  NoOpDispatcher.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 20.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKNoopDispatcher.h"
#import "VAKConstants.h"

@implementation VAKNoopDispatcher

+ (instancetype)sharedNoopDispatcher {
    static VAKNoopDispatcher *noop = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        noop = [[self alloc] init];
    });
    
    return noop;
}

#pragma mark Protocol API

- (id)pull:(NSString *)findId {
    return kVAKNoopDispatcherPullResult;
}

- (BOOL)push {
    return YES;
}

@end
