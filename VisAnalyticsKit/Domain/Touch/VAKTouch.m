//
// Created by VisAnalyticsKit on 29.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import "VAKTouch.h"
#import "VAKConstants.h"

@implementation VAKTouch

#pragma mark TRANSFORMABLE PROTOCOL

+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
  VAKTouch *touch = [[VAKTouch alloc] init];

  [properties enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {

    if ([key isEqualToString:kVAKTouchType]) {
      touch.type = (UITouchType) [value integerValue];
      return;
    }

    if ([key isEqualToString:kVAKTouchPhase]) {
      touch.phase = (UITouchPhase) [value integerValue];
      return;
    }

    if ([key isEqualToString:kVAKTouchView] || [key isEqualToString:kVAKTouchWindow]) {
      value = NSClassFromString(value);
    }

    if ([touch respondsToSelector:NSSelectorFromString(key)]) {
      [touch setValue:value forKey:key];
    }
  }];

  return touch;
}

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
  return nil;
}

// ------------------------------------------------------------
#pragma mark METHODS

- (CGPoint)locationInView:(nullable UIView *)view {
  return CGPointMake([_location[@"X"] floatValue], [_location[@"Y"] floatValue]);
}

- (CGPoint)previousLocationInView:(nullable UIView *)view {
  return CGPointMake([_previousLocation[@"X"] floatValue], [_previousLocation[@"Y"] floatValue]);
}


@end
