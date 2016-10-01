//
//  VAKProvGeneration.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 07.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvGeneration.h"
#import "NSDate+VAKISOFormat.h"
#import "VAKMacros.h"

static NSString *const VAKProvGenerationIdPrefix = @"generation";

@implementation VAKProvGeneration

- (instancetype)initWithDefaults {
  self = [super init];

  if (self) {
    _time = [NSDate date];
    self.id = VAK_ID(
      @"%@%s%@",
      VAKProvGenerationIdPrefix,
      kVAKProvDelimiter,
      [self.class vak_shortId]
    );
  }
  
  return self;
}

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
  NSMutableDictionary<NSString *, id> *props = [NSMutableDictionary
    dictionaryWithDictionary:[super vak_objectAsDictionary]
  ];

  [self addProp:props[self.id] forKey:kVAKProvEntityPrefixed withProp:_entity];
  [self addProp:props[self.id] forKey:kVAKProvTimePrefixed withProp:[NSDate vak_isoFormatDate:_time]];
  [self addProp:props[self.id] forKey:kVAKProvActivityPrefixed withProp:_activity];

  return [NSDictionary dictionaryWithDictionary:props];
}


@end
