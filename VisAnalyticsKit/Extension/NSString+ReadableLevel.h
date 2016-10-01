 //
//  NSString+ReadableLevel.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 10.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import "VAKConstants.h"

/**
 *  an extension to the build-in string type,
 *  that's responsible for a human readable log level output
 */
@interface NSString (ReadableLevel)

/**
 *  returns a human readable log level by passing a number between 0 - 7
 *
 *  @param NSNumber lvl the log level range(0-7)
 *
 *  @return NSString the log level name
 */
+ (NSString *)vak_level:(NSNumber *)lvl;

/**
 *  same as level except that the param is of the enum type VAKLogLevels
 *
 *  @param VAKLogLevels lvl
 *
 *  @return @see level
 */
+ (NSString *)vak_levelFromEnum:(VAKLogLevels)lvl;

@end
