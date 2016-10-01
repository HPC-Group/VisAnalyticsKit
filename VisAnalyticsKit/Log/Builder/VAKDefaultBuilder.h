//
//  VAKDefaultBuilder.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 17.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKLogManagerBuilderProtocol.h"
#import "VAKLogManager.h"

/**
 *  The responsiblity of the builder is to configure a logManager
 *  with and merge some default values into the config given.
 *  This diverges from the classical builder pattern.
 */
@interface VAKDefaultBuilder : NSObject<VAKLogManagerBuilderProtocol>

/**
 *  the config dictionary
 */
@property(atomic) NSMutableDictionary<NSString *, id> *config;

// --

/**
 *  configures the logManager by building a complete config dictionary
 *
 *  @param NSDictionary<NSString *, id> config the config dictionary for a complete
 *                                      example checkout out the @see Readme.md
 *
 *  @return VAKLogManager a configured and usable logManager
 */
- (VAKLogManager *)build:(NSDictionary<NSString *, id> *)config;

@end
