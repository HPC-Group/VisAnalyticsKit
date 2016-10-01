//
//  VAKProvAgent.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <VisAnalyticsKit/VisAnalyticsKit.h>
#import "VAKProvWritingSoftwareAgent.h"

@implementation VAKProvWritingSoftwareAgent

- (instancetype)initWithDefaults {
  self = [super init];

  if (self) {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:self.class];
    NSDictionary *infoDictionary = [frameworkBundle infoDictionary];
        
    self.id = kVAKProvWritingAgentLabel;
        
    [self setAttributesWithDictionary:@{
      kVAKProvTypePrefixed:kVAKProvTypeSoftwareAgent,
      kVAKProvStateKit:frameworkBundle.bundleIdentifier,
      kVAKProvStateKitVersion:[NSString stringWithFormat:@"%@", infoDictionary[@"CFBundleShortVersionString"]],
      kVAKProvAttributeLabel:kVAKProvWritingAgentLabel
    }];
  }

  return self;
}

@end
