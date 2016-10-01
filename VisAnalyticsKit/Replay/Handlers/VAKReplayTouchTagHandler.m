//
// Created by VisAnalyticsKit on 29.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKReplayTouchTagHandler.h"
#import "VAKConstants.h"
#import "VAKTouchCollection.h"

@implementation VAKReplayTouchTagHandler

@synthesize tag = _tag;

#pragma mark IMPL

- (instancetype)init {
  self = [super init];

  if (self) {
    _tag = kVAKTagsTouches;
  }

  return self;
}

- (id)handleState:(id<VAKStateProtocol>)state {
  NSArray *touchList = state.data[kVAKStateDataTouches];

  VAKTouchCollection *collection = [VAKTouchCollection open];
  [collection addTouchesList:touchList];

  return collection;
}


@end
