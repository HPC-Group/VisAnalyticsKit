//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKStateSettingsSelection.h"
#import "VAKStateProtocol.h"
#import "VAKReplayTagHandlerProtocol.h"

@interface VAKStateSettingsSelection()

@property (nonatomic) id<VAKStateProtocol> state;
@property (nonatomic) NSDictionary *handlers;

@end

@implementation VAKStateSettingsSelection

- (instancetype)initWithState:(id <VAKStateProtocol>)state andTagHandlers:(NSDictionary *)handlers {
  self = [super init];

  if (self) {
    super.selectionType = VAKStateSettingsSelectionType;
    _state = state;
    _handlers = handlers;
  }

  return self;
}

- (void)handleSettings {
  if (_handlers[kVAKTagsSettings]) {
    [_handlers[kVAKTagsSettings] handleState:_state];
  }
}

@end
