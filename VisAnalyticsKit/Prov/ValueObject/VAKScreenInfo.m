//
// Created by VisAnalyticsKit on 22.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <UIKit/UIKit.h>

#import "VAKScreenInfo.h"
#import "VAKConstants.h"
#import "VAKProvKeys.h"

@interface VAKScreenInfo ()

@property CGFloat width;
@property CGFloat height;
@property VAKInterfaceOrientation uiOrientation;

@end

#pragma mark PUBLIC

@implementation VAKScreenInfo

- (instancetype)init {
  self = [super init];

  if (self) {
    _uiOrientation = (VAKInterfaceOrientation) [[UIApplication sharedApplication] statusBarOrientation];
    _width = [UIScreen mainScreen].bounds.size.width;
    _height = [UIScreen mainScreen].bounds.size.height;
  }

  return self;
}

+ (id<VAKTransformableProtocol>)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
  VAKScreenInfo *info = [[VAKScreenInfo alloc] init];

  info.uiOrientation = (VAKInterfaceOrientation)[properties[kVAKProvUIOrientation] integerValue];
  info.width = (CGFloat) [properties[kVAKProvScreenWidth] floatValue];
  info.height = (CGFloat) [properties[kVAKProvScreenHeight] floatValue];

  return info;
}

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {

  return @{
    kVAKProvUIOrientation:@(_uiOrientation),
    kVAKProvScreenWidth:@(_width),
    kVAKProvScreenHeight:@(_height)
  };
}


@end
