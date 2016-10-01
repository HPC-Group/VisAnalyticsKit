//
//  VAKBaseState.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKAbstractModel.h"
#import "VAKStateProtocol.h"
#import "VAKTaggableProtocol.h"

/**
 * The state object that's being persisted and transformed.
 * It's at the heart of the framework.
 */
@interface VAKState : VAKAbstractModel<VAKStateProtocol, VAKTaggableProtocol>

/**
 *  Factory method to allocat and init a state
 *
 *  @return VAKStateProtocol initialized and ready for use
 */
+ (instancetype)create;

/**
 * Factory method to instantiate a state
 */
+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties;

/**
 * retrieves an array of all keys that define a state.
 * to be used by query builders
 *
 * @return NSArray
 */
+ (NSArray *)getStateKeys;

@end
