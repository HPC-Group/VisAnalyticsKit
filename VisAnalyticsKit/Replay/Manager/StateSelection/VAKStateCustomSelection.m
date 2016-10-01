//
// Created by VisAnalyticsKit on 02.05.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKStateBaseSelection.h"
#import "VAKStateCustomSelection.h"
#import "VAKStateProtocol.h"

@implementation VAKStateCustomSelection

- (instancetype)initWithState:(id<VAKStateProtocol>)state andTagHandlers:(NSDictionary *)handlers {
  self = [super init];

  if (self) {
    super.selectionType = VAKStateCustomSelectionType;
    _handlers = handlers;
    _state = state;
  }

  return self;
}

- (void)handleState {
  // to be implemented by children
}

@end
