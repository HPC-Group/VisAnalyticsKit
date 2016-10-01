//
// Created by VisAnalyticsKit on 29.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKReplayViewTagHandler.h"
#import "VAKConstants.h"

@implementation VAKReplayViewTagHandler

@synthesize tag = _tag;

#pragma mark INITS

- (instancetype)init {
  self = [super init];

  if (self) {
    _tag = kVAKTagsViews;
  }

  return self;
}

- (id)handleState:(id<VAKStateProtocol>)state {
  return @"";
}

@end
