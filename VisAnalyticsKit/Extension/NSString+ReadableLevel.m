//
//  NSString+ReadableLevel.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 10.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "NSString+ReadableLevel.h"

@implementation NSString (ReadableLevel)

+ (NSString *)vak_level:(NSNumber *)lvl {
    return [self levelMap][lvl] ?: @"INFO";
}

+ (NSString *)vak_levelFromEnum:(VAKLogLevels)lvl {
    return [self vak_level:@(lvl)];
}

+ (NSDictionary<NSNumber *, NSString *> *)levelMap {
    return @{
        @(VAKLevelEmergency):   @"EMERGENCY",
        @(VAKLevelAlert):       @"ALERT",
        @(VAKLevelCritical):    @"CRITICAL",
        @(VAKLevelError):       @"ERROR",
        @(VAKLevelWarning):     @"WARNING",
        @(VAKLevelNotice):      @"NOTICE",
        @(VAKLevelInfo):        @"INFO",
        @(VAKLevelDebug):       @"DEBUG"
    };
}

@end
