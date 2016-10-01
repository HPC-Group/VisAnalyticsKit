//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKStateBaseSelection.h"

@class UIViewController;

/**
 * A oop response object to make things clearer and that spares us from
 * calls to isKindOfClass calls.
 */
@interface VAKStateControllerSelection : VAKStateBaseSelection

/**
 * the next view controller to show in the replay
 */
@property(nonatomic) UIViewController *selectedController;

#pragma mark METHODS

/**
 * inits the selection with the selected view controller to pass on
 *
 * @param UIViewController selectedController  the selected view controller passed on from the replay manager
 *
 * @return VAKStateControllerSelection
 */
- (instancetype)initWithController:(UIViewController *)selectedController;

@end
