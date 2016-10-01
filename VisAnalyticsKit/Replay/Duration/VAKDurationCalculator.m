//
// Created by VisAnalyticsKit on 26.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKDurationCalculator.h"

@implementation VAKDurationCalculator

- (NSTimeInterval)calcDurationBetween:(NSDate *)start andEnd:(NSDate *)endDate {
  return [endDate timeIntervalSinceDate:start];
}

- (NSArray *)batchCalcDuration:(NSArray<NSDate *> *)dates {
  NSMutableArray *durations = [[NSMutableArray alloc] init];
  
  for (NSUInteger i = 0; i < dates.count; i++) {
    NSUInteger nextElemIndex = i + 1;
    
    if (nextElemIndex < dates.count) {
       [durations addObject:@([self calcDurationBetween:dates[i] andEnd:dates[nextElemIndex]])];
    }
  }
  
  return durations;
}

- (NSArray *)calcDurationForStates:(NSArray<id<VAKStateProtocol>> *)states {
  NSMutableArray *durations = [[NSMutableArray alloc] init];
  
  for (NSUInteger i = 0; i < states.count; i++) {
    NSUInteger nextElemIndex = i + 1;
    
    if (nextElemIndex < states.count) {
      id<VAKStateProtocol> earlierState = states[i];
      id<VAKStateProtocol> laterState = states[nextElemIndex];

      [durations addObject:@([self calcDurationBetween:earlierState.timestamp andEnd:laterState.timestamp])];
    }
  }
  
  return durations;
}

- (NSArray *)calcDurationForSession:(VAKSession *)session {
  return [self calcDurationForStates:[session getStates]];
}

@end
