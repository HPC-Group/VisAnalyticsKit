//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKStateDoneSelection.h"

@implementation VAKStateDoneSelection

- (instancetype)init {
  self = [super init];

  if (self) {
    super.selectionType = VAKStateDoneSelectionType;
  }

  return self;
}

@end
