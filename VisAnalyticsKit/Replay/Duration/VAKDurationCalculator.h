//
// Created by VisAnalyticsKit on 26.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import <VisAnalyticsKit/VisAnalyticsKit.h>

/**
 * Responsible for calculating duration between two states.
 */
@interface VAKDurationCalculator : NSObject
/**
 * calculates the duration between two given nsdates
 * @param NSDate start the starting date (before the end date)
 * @param NSDate endDate the ending date (after the starting date)
 * @return NSTimeInterval
 */
- (NSTimeInterval)calcDurationBetween:(NSDate *)start andEnd:(NSDate *)endDate;

/**
 * calculates a duration for a list of NSDates
 *
 * @param NSArray<NSDate> dates a list of dates that should be compared
 * @return NSArray a list of result durations (dates.count - 1)
 */
- (NSArray *)batchCalcDuration:(NSArray<NSDate *> *)dates;

/**
 * @see batchCalcDuration but instead of a simple list of dates
 * we pass in a list of states
 */
- (NSArray *)calcDurationForStates:(NSArray<id<VAKStateProtocol>> *)states;

/**
 * basically a convenience method to just pass in a session and get the durations between the saved states
 *
 * @return NSArray
 */
- (NSArray *)calcDurationForSession:(VAKSession *)session;

@end
