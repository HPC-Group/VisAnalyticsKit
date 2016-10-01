//
//  NSDate+VAKISOFormat.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 24.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKConstants.h"

/**
 *  extends the built-in data functionality with the
 *  ability to transform a date to an ISO_8601 formatted string @see VAKISO_8601
 *  and retrieve a NSDate from an ISO_8601 formatted string.
 *  due to best practices the methods are prefixed by 'vak_'
 */
@interface NSDate (VAKISOFormat)

/**
 *  formats a NSDate to ISO_8601 formatted string
 *
 *  @param NSDate dateToFormat
 *
 *  @return NSString that's ISO_8601 formatted
 */
+ (NSString *)vak_isoFormatDate:(NSDate *)dateToFormat;

/**
 *  creates a NSDate from a ISO_8601 formatted string
 *
 *  @param NSString formattedString the ground for the NSDate
 *
 *  @return NSDate 
 */
+ (NSDate *)vak_dateFromIS08601:(NSString *)formattedString;

@end
