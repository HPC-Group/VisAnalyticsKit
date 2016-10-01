//
//  VAKStateLogDispatcher.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKConsoleProvider.h"

/**
 * Write only implementation of the persistence provider with the NSLog util.
 * Important: The usage of this provider is discouraged because it messes up the actual systemlog!
 * Also refer to: http://doing-it-wrong.mikeweller.com/2012/07/youre-doing-it-wrong-1-nslogdebug-ios.html
 * Implemenation is only a prove of concept.
 */
@interface VAKNSLogProvider : VAKConsoleProvider

@end
