//
//  VAKLogRegistrationBroker.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 28.01.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKLogManager.h"

/**
 *  Responsible for adding views and events to the logger via a dictionary.
 *  For the sake of a shorter class the methods concerning the configuration were put in this category.
 */
@interface VAKLogRegistrationBroker : NSObject

/**
 *  a set of interceptors that are performed to gather data
 */
@property(readonly, nonatomic) NSMutableOrderedSet *interceptors;

/**
 *  the shared logManager
 */
@property(readonly, nonatomic) VAKLogManager *manager;

// --

/**
 *  configures the loggerManager by inserting a dictionary that's built of
 *  vocabulary from the DSL defined in VAKConstants to have a nicer and decoupled
 *  API.
 *
 *  @param NSDictionary configDictionary the dictionary with keys from the DSL 
 */
- (void)configureWithDictionary:(NSDictionary *)configDictionary;

/**
 *  removes all log interceptors aka aspects
 */
- (void)unregisterInterceptors;

@end
