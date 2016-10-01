//
// Created by VisAnalyticsKit on 30.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKStateKeyframeSelection.h"
#import "VAKStateProtocol.h"
#import "VAKReplayTagHandlerProtocol.h"

// ----------------------------------------
#pragma mark PRIVATE

// \cond HIDDEN_SYMBOLS
@interface VAKStateKeyframeSelection()

@property(nonatomic) NSArray<id<VAKStateProtocol>> *keyframes;
@property(nonatomic) NSDictionary *handlers;

@end
// \endcond

// ----------------------------------------
#pragma mark PUBLIC

@implementation VAKStateKeyframeSelection

- (instancetype)initWithState:(NSArray *)keyframes andTagHandlers:(NSDictionary *)handlers {
  self = [super init];

  if (self) {
    super.selectionType = VAKStateKeyframeSelectionType;
    _keyframes = keyframes;
    _handlers = handlers;
  }

  return self;
}

- (void)handleKeyframes {
  if (_handlers[kVAKTagsKeyframe]) {
    id<VAKStateProtocol> firstState = [_keyframes firstObject];
    id<VAKStateProtocol> lastState = [_keyframes lastObject];

    for (id<VAKStateProtocol> reset in _keyframes) {
      id<VAKTaggableProtocol> taggable = (id<VAKTaggableProtocol>) reset;

      if ([taggable hasTag:@"reset"]) {
        [_handlers[kVAKTagsKeyframe] handleState:reset];
      }
    }

    [_handlers[kVAKTagsKeyframe] handleState:firstState];

    if (_keyframes.count > 1) {
      [_handlers[kVAKTagsKeyframe] handleState:lastState];
    }
  }
}


@end
