//
//  VAKStateFactory.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 30.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKStateProtocol.h"
#import "VAKStateFactoryProtocol.h"

/**
 * Implementation of the StateFactoryProtocol to be used whenever
 * a state object is built
 */
@interface VAKStateFactory : NSObject<VAKStateFactoryProtocol>

@end
