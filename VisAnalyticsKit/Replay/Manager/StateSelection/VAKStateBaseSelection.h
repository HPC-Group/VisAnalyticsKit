//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 * defines the different selection types to be handled by the replay manager
 */
typedef NS_ENUM(NSUInteger, VAKStateSelectionType) {
  VAKStateDoneSelectionType,
  VAKStateControllerSelectionType,
  VAKStateTouchSelectionType,
  VAKStateKeyframeSelectionType,
  VAKStateSettingsSelectionType,
  VAKStateCustomSelectionType
};

/**
 * Common base for all selection type response objects.
 * Special behavior that handles state
 */
@interface VAKStateBaseSelection : NSObject

/**
 * sets the specific selection type to be used in the replay loop
 */
@property(nonatomic) VAKStateSelectionType selectionType;

@end
