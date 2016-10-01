//
// Created by VisAnalyticsKit on 12.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 * takes care of formatting data to a specific format
 */
@protocol VAKFormatterProtocol <NSObject>

/**
 * transforms the passed in data accordingly to the implementation
 * of the underlying format selector
 *
 * @param NSDictionary the data to transform including a reference to the
 *          Formatter to be used which must be ignored
 * @return NSString the data neatly formatted as a string
 */
+ (NSString *)vak_formatData:(NSDictionary *)data;

@end
