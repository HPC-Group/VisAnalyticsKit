//
//  VAKSoftwareAgent.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

// Custom
#import <VisAnalyticsKit/VisAnalyticsKit.h>
#import "VAKScreenInfo.h"


@implementation VAKProvDelegatingSoftwareAgent

- (instancetype)initWithDefaults {
  self = [super init];

  if (self) {
    self.id = kVAKProvDelegatingSoftwareAgentLabel;
    [self setAttributesWithDictionary:[self.class getAgentInfo]];
    [self setLabel:kVAKProvDelegatingSoftwareAgentLabel];
    [self setClientAttributes];
  }

  return self;
}

- (void)setClientAttributes {
  if ([VAKLogManager sharedLogManager].clientInfo) {
    [self setAttributesWithDictionary:[VAKLogManager sharedLogManager].clientInfo];
  }
}

- (NSDictionary *)getClientInfo {
  return [self getAttribute:kVAKConfigClient];
}

+ (NSDictionary<NSString *, id> *)getAgentInfo {
  return @{
    kVAKProvOSName:kVAKOSName,
    kVAKProvOSVersion:[[NSProcessInfo processInfo] operatingSystemVersionString],
    kVAKProvTypePrefixed:kVAKProvTypeSoftwareAgent
  };
}

- (void)setScreenInfo {
  VAKScreenInfo<VAKTransformableProtocol> *info = [[VAKScreenInfo alloc] init];
  [self setAttributesWithDictionary:[info vak_objectAsDictionary]];
}

- (VAKInterfaceOrientation)getInterfaceOrientation {
  VAKInterfaceOrientation orientation = VAKOrientationUnknown;

  if ([self hasAttribute:kVAKProvUIOrientation]) {
    orientation = (VAKInterfaceOrientation)
    [[self getAttribute:kVAKProvUIOrientation] integerValue];
  }

  return orientation;
}

#pragma mark CAUSER

- (void)setCauser:(NSDictionary<NSString *,NSString *> *)causerDict {
  if (causerDict) {
    [self setAttributesWithDictionary:causerDict];
  }
}

- (NSDictionary<NSString *, NSString *> *)getCauser {
  NSMutableDictionary *causer = [[NSMutableDictionary alloc] init];
  
  NSString *callerName = [self getAttribute:kVAKCallerName];
  NSString *calledMethod = [self getAttribute:kVAKMethodCalled];
  
  if (callerName) {
    causer[kVAKCallerName] = callerName;
  }
  
  if (calledMethod) {
    causer[kVAKMethodCalled] = calledMethod;
  }
  
  return causer;
}

- (NSString *)getCallerName {
  NSDictionary *causer = [self getCauser];
  NSString *callerName = @"";

  if (causer && causer[kVAKCallerName]) {
    callerName = causer[kVAKCallerName];
  }

  return callerName;
}

@end
