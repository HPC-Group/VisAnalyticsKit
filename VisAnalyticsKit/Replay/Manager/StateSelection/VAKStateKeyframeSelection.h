//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKStateBaseSelection.h"

@protocol VAKStateProtocol;

/**
 * A selection response object that takes care of states tagged as keyframe
 */
@interface VAKStateKeyframeSelection : VAKStateBaseSelection

/**
 * inits the selection response with a list of keyframes and all registered handlers
 *
 * @param NSArray keyframes the list of states aka keyframes to be simplified and or handled
 * @param NSDictionary handlers a dictionary of tag handlers
 *
 * @return VAKStateKeyframeSelection
 */
- (instancetype)initWithState:(NSArray *)keyframes andTagHandlers:(NSDictionary *)handlers;

/**
 * the only action visible to the replay manager
 */
- (void)handleKeyframes;

@end
