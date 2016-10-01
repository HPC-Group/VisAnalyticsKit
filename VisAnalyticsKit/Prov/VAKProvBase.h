//
//  VAKProvBase.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 07.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKTransformableProtocol.h"
#import "VAKProvKeys.h"

/**
 *  a base provenance object that shares the basic features all provenance concepts share
 *  id and attributes
 */
@interface VAKProvBase : NSObject<VAKTransformableProtocol>

/**
 *  the node identifier according to the
 */
@property(readwrite, copy) NSString *id;

/**
 *  an arbitrary set of key/value pairs
 */
@property(readwrite) NSMutableDictionary<NSString *, id> *attributes;

// --

/**
 *  abstract factory to create the various types of provenance components
 *
 *  @param provClass  <#provClass description#>
 *  @param properties <#properties description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)createProvComponent:(Class)provClass withProperties:(NSDictionary<NSString *,id> *)properties;

/**
 *  convinience helper that sets a hskprov object from a dicitonary
 *  and transforms date strings to dates
 *
 *  @param NSDictionary<NSString *, id>properties  the properties to set
 */
- (void)enumeratingSetter:(NSDictionary<NSString *, id> *)properties;

/**
 *  convenience method to set attributes at once
 *
 *  @param NSDictionary<NSString *, id> dictionary a collection of attributes and their values
 */
- (void)setAttributesWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

/**
 *  wrapper for setting attributes on the parent object
 *
 *  @param NSString key  the attribute name
 *  @param id value      the content of the attribute
 */
- (void)setAttribute:(NSString *)key value:(id)value;

/**
 *  checks whether or not an attribute exists
 *
 *  @param  NSString attribute  the attribute to look for
 *  @return BOOL true if attribute was found
 */
- (BOOL)hasAttribute:(NSString *)attribute;

/**
 *  retrieves a given attribute by it's name
 *
 *  @param NSString attribute the attribute to fetch
 *
 *  @return id  the attribute vaule
 */
- (id)getAttribute:(NSString *)attribute;

/**
 *  helper to check if a given value is set, if so add it else don't
 *  SIDEEFFECTS: sets key value pairs of a dictionary
 *
 *  @param props <#props description#>
 *  @param key   <#key description#>
 *  @param prop  <#prop description#>
 */
- (void)addProp:(NSMutableDictionary<NSString *, id> *)props forKey:(NSString *)key withProp:(id)prop;

/**
 *  gets the inner dictionary
 *
 *  @param NSDictionary<NSString *, NSDictionary<NSString *,id> *>  dictionary a dictionary of dictionaries
 *  @return NSDictionary<NString *, id>
 */
- (NSDictionary<NSString *, id> *)getInner:(NSDictionary<NSString *, NSDictionary<NSString *,id> *> *)dictionary;

@end
