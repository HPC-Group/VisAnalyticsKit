//
//  VAKTransformableDomainProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 24.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>


/**
 *  this used to be the job of a specialised Transformer Service until
 *  the service was not able to handle different types of domain objects
 *  without duplicating much of the same code or through some cruel kind
 *  of inheritance. this way the actual transformation code is at the heart
 *  of the object to be transformed
 */
@protocol VAKTransformableProtocol <NSObject>

@required

/**
 *  Factory method that let's us create domain objects from a dictionary
 *
 *  @param NSDictionary<NSString *, id> properties the key/values that should make up the domain object
 *
 *  @return id<VAKTransformableProtocol> the instantiated domain object
 */
+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties;

/**
 *  represents a domain object as a dictionary
 *
 *  @return NSDictionary<NSString *, id> 
 */
- (NSDictionary<NSString *, id> *)vak_objectAsDictionary;


@end
