//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <UIKit/UIKit.h>
#import "VAKStateControllerSelection.h"

@implementation VAKStateControllerSelection

- (instancetype)initWithController:(UIViewController *)selectedController {
  self = [super init];

  if (self) {
    super.selectionType = VAKStateControllerSelectionType;
    _selectedController = selectedController;
  }

  return self;
}

@end
