//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import "VAKStateBaseSelection.h"

@protocol VAKStateProtocol;

/**
 * A selection response object that handles states tagged as settings
 */
@interface VAKStateSettingsSelection : VAKStateBaseSelection

/**
 * inits the selection response with a state and a dictionary of tag handlers
 *
 * @param id<VAKStateProtocol> state  the state to be handled
 * @param NSDictionary handlers a dictionary of tag handlers
 *
 * @return VAKStateKeyframeSelection
 */
- (instancetype)initWithState:(id<VAKStateProtocol>)state andTagHandlers:(NSDictionary *)handlers;

/**
 * public interface to be used by the replay manager
 */
- (void)handleSettings;

@end
