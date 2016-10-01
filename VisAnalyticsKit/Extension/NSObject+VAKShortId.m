//
// Created by VisAnalyticsKit on 17.07.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "NSObject+VAKShortId.h"


@implementation NSObject (VAKShortId)

+ (NSString *)vak_shortId {
  NSArray *chunks = [[[NSProcessInfo processInfo] globallyUniqueString] componentsSeparatedByString:@"-"];
  return chunks[chunks.count - 1];
}

@end
