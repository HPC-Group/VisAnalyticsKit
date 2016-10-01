//
//  NSDate+VAKISOFormat.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 24.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "NSDate+VAKISOFormat.h"

@implementation NSDate (VAKISOFormat)

+ (NSString *)vak_isoFormatDate:(NSDate *)dateToFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kVAKISO_8601;
    
    return [formatter stringFromDate:dateToFormat];
}

+ (NSDate *)vak_dateFromIS08601:(NSString *)formattedString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kVAKISO_8601;
    
    return [formatter dateFromString:formattedString];
}

@end
