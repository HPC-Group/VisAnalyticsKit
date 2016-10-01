//
// Created by VisAnalyticsKit on 15.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKVectorFormatter.h"

@implementation VAKVectorFormatter

+ (NSString *)vak_formatData:(NSDictionary *)data {
  NSString *formatted = [[NSString alloc] init];

  @try {
    formatted = [NSString stringWithFormat:@"(%@)", [data[kVAKStateDataVector] componentsJoinedByString:@" "]];

  } @catch (NSException *e) {
    NSLog(@"- VAKError: %@: %@", NSStringFromClass(self.class), e.reason);
  }


  return formatted;
}

@end
