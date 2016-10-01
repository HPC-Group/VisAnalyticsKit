//
//  VAKKeyChain.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 *  this is a wrapper that interfaces the ios KeyChain
 *  inspired by and in part taken from http://hayageek.com/ios-keychain-tutorial/
 */
@interface VAKKeychain : NSObject

/**
 *  the service that uses a key
 */
@property(copy) NSString *service;

/**
 *  factory method to create a keychain
 *
 *  @param service <#service description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)initWithService:(NSString *)service;

/**
 *  CRUD op => this is the c
 *  inserts a key/value pair into the keychain
 *
 *  @param NSString key  the key to be saved
 *  @param NSData data  the value of the key
 *
 *  @return BOOL if successful
 */
- (BOOL)create:(NSString *)key data:(NSData *)data;

/**
 *  CRUD op => this is the r
 *  reads a specified key and returns it's value
 
 *  @param NSString key the key to retrieve
 *
 *  @return NSData the value of the key
 */
- (NSData *)read:(NSString *)key;

/**
 *  convenience method that wraps read
 *
 *  @param NSString key @see read
 *
 *  @return NSString the keyValue as string
 */
- (NSString *)readAsString:(NSString *)key;

/**
 *  CRUD op => this is the u
 *  updates the specified key with the data
 *
 *  @param NSString key  the key to update
 *  @param NSData data the data to update the key with
 *
 *  @return BOOL if op is successful
 */
- (BOOL)update:(NSString*)key data:(NSData*)data;

/**
 *  CRUD op => this is the d
 *  deletes a key value pair
 *
 *  @param NSString key the key to remove
 *
 *  @return BOOL if successful
 */
- (BOOL)remove:(NSString*)key;

@end
