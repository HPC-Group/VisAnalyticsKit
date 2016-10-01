//
//  NoOpDispatcher.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 20.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKRemoteDispatchProtocol.h"

/**
 *  The noop dispatcher is a standin for an actual dispatcher, that
 *  actually does some work. This dispatcher is to be used with the various 
 *  types of console providers that don't have a real endpoint.
 *  It's a singleton to be easy on system resources like RAM, also there is no need 
 *  in having multiple instances of a noop anything.
 */
@interface VAKNoopDispatcher : NSObject<VAKRemoteDispatchProtocol>

/**
 *  singleton factory for the noop dispatcher
 *
 *  @return a singleton of the noop dispatcher to be shared by all consumers
 */
+ (instancetype)sharedNoopDispatcher;

@end
