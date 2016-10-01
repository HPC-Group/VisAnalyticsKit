//
// Created by VisAnalyticsKit on 29.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

#import <VisAnalyticsKit/VisAnalyticsKit.h>

/**
 * Takes care of the actions to take when a specific state with specific tag comes in while replaying.
 */
@protocol VAKReplayTagHandlerProtocol <NSObject>

@required

/**
 * the tag the handler takes care of
 */
@property(nonatomic, copy) NSString *tag;

/**
 * makes the appropriate choices what to do with a certain kind of state
 */
- (id)handleState:(id<VAKStateProtocol>)state;

@end
