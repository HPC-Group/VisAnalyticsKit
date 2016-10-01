//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKStateTouchSelection.h"


@implementation VAKStateTouchSelection

- (instancetype)initWithTouches:(VAKTouchCollection *)touches {
  self = [super init];

  if (self) {
    super.selectionType = VAKStateTouchSelectionType;
    _touches = touches;
  }

  return  self;
}

@end
