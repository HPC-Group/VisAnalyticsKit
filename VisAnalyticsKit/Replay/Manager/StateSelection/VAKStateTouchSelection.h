//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

#import "VAKStateBaseSelection.h"
#import "VAKTouchCollection.h"

/**
 * The selected state had touches. So we have to respond accordingly by returning a touchselection object.
 */
@interface VAKStateTouchSelection : VAKStateBaseSelection

/**
 * The saved touches
 */
@property(nonatomic) VAKTouchCollection *touches;

#pragma mark METHODS

/**
 * inits the selection with the selected touchCollection passed on from the state
 *
 * @param VAKTouchCollection touches   the touches saved from previous sessions
 *
 * @return VAKStateTouchSelection
 */
- (instancetype)initWithTouches:(VAKTouchCollection *)touches;

@end
