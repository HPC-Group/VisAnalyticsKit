//
// Created by VisAnalyticsKit on 10.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKTouchCollection.h"
#import "UITouch+VAKTransformable.h"
#import "VAKTouch.h"

@interface VAKTouchCollection()

@property(nonatomic) NSMutableArray<NSArray *> *touchCollection;
@property(nonatomic) NSMutableArray *startedTouch;

@end

@implementation VAKTouchCollection

// -
#pragma mark LifeCylce

+ (instancetype)open {
    VAKTouchCollection *collection = [[VAKTouchCollection alloc] init];

    return collection;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _touchCollection = [[NSMutableArray alloc] init];

        return self;
    }

    return self;
}

- (void)close {

}

// -
#pragma mark API

- (void)addTouchesList:(NSArray<NSArray *> *)list {

  for (NSArray *touchGroup in list) {
    NSMutableArray *newTouchGroup = [[NSMutableArray alloc] init];

    for (NSDictionary *touchDict in touchGroup) {
      [newTouchGroup addObject:[VAKTouch vak_createWithDictionary:touchDict]];
    }

    [_touchCollection addObject:newTouchGroup];
  }
}

- (void)addTouches:(NSArray *)touches {
  [_touchCollection addObject:touches];
}

- (void)addTouch:(UITouch *)touch {
  if (touch.phase == UITouchPhaseBegan) {
    _startedTouch = [[NSMutableArray alloc] init];
    [_startedTouch addObject:[touch vak_objectAsDictionary]];

  } else if (touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded) {
    [_startedTouch addObject:[touch vak_objectAsDictionary]];
    [_touchCollection addObject:_startedTouch];

    _startedTouch = nil;
  }
}

- (NSArray *)getTouches {
    return [NSArray arrayWithArray:_touchCollection];
}

- (NSNumber *)count {
    return @([_touchCollection count]);
}

- (NSSet *)getSet {
  return [NSSet setWithArray:[self allObjects]];
}

- (NSSet *)getTouchesBeganSet {
  return [self getTouchesByPhase:UITouchPhaseBegan];
}

- (NSSet *)getTouchesEndedSet{
  return [self getTouchesByPhase:UITouchPhaseEnded];
}

- (NSSet *)getTouchesMovedSet{
  return [self getTouchesByPhase:UITouchPhaseMoved];
}

- (NSSet *)getTouchesCancelledSet{
  return [self getTouchesByPhase:UITouchPhaseCancelled];
}

- (NSSet *)getTouchesByPhase:(UITouchPhase)phase {
  return [NSSet setWithArray:[self getTouchesArrayForPhase:phase]];
}

- (NSArray *)getTouchesArrayForPhase:(UITouchPhase)phase {
  NSMutableArray *touches = [[NSMutableArray alloc] init];

  for (NSArray *inner in _touchCollection) {
    for (VAKTouch *touch in inner) {
      if (touch.phase == phase) {
        [touches addObject:touch];
      }
    }
  }

  return touches;
}

- (NSArray *)allObjects {
  NSMutableArray *allObjects = [[NSMutableArray alloc] init];

  for (NSArray *inner in _touchCollection) {
    for (VAKTouch *touch in inner) {
      [allObjects addObject:touch];
    }
  }

  return allObjects;
}


@end
