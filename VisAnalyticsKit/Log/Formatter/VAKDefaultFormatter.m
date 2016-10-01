//
// Created by VisAnalyticsKit on 18.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKDefaultFormatter.h"


@implementation VAKDefaultFormatter

+ (NSString *)vak_formatData:(NSDictionary *)data {
  NSMutableArray *chunks = [[NSMutableArray alloc] init];

  @try {
    for (NSString *key in [data allKeys]) {
      if (![key isEqualToString:kVAKStateDataFormatter] && ![key isEqualToString:kVAKSerializerInfo]) {
        [chunks addObject:[NSString stringWithFormat:@"%@:%@", key, data[key]]];
      }
    }

  } @catch (NSException *e) {
    NSLog(@"- VAKError: %@: %@", NSStringFromClass(self.class), e.reason);
  }

  return [chunks componentsJoinedByString:@", "];
}
@end
