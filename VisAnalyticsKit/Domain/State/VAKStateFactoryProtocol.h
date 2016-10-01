//
//  VAKStateFactoryProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 10.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKStateProtocol.h"

/**
 * Defines the protocol all state factories have to adhere to.
 * This is used to keep things loosely coupled.
 */
@protocol VAKStateFactoryProtocol <NSObject>

/**
 * Creates a state object by using a dictionary.
 * The allocation is not necessarily part of the creation and often times
 * a concern of the actual state object.
 *
 * @param NSDictionary dictionary of state data
 *
 * @return id<VAKStateProtocol> a valid state object
 */
+ (id<VAKStateProtocol>)create:(NSDictionary *)stateDictionary;

@end
