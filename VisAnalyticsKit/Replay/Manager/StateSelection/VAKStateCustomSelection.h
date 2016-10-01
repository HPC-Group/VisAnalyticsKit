//
// Created by VisAnalyticsKit on 02.05.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKStateBaseSelection.h"

@protocol VAKStateProtocol;

/**
 * This is the base class for all custom state selections and has to be extend from custom
 * classes on the client side
 */
@interface VAKStateCustomSelection : VAKStateBaseSelection

/**
 * the handlers that were registered in the replay manager. These handlers have special behavior to
 * treat the state at hand accordingly.
 */
@property(nonatomic) NSDictionary *handlers;
/**
 * the state to handle
 */
@property(nonatomic) id<VAKStateProtocol> state;

#pragma mark METHODS

- (instancetype)initWithState:(id<VAKStateProtocol>)state andTagHandlers:(NSDictionary *)handlers;

/**
 * this method should handle the actions that have to occur in a selection
 */
- (void)handleState;

@end
