//
//  VAKConsoleProvider.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 15.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKPersistenceProviderProtocol.h"

/**
 *  A console provider that instead of writing state to a persistent source, just prints it to the volatile console 
 *  without inserting anything to any kind of physical log
 */
@interface VAKConsoleProvider : NSObject<VAKPersistenceProviderProtocol>

/**
 *  a list of fields that should be displayed when logging to the console
 */
@property(nonatomic, readwrite) NSArray<NSString *> *fieldsWhitelist;
/**
 *  a list of tags that will not show up on screen
 */
@property(nonatomic, readwrite) NSArray<NSString *> *tagsBlacklist;

// --

/**
 *  helper to keep things dry
 *  is responsible for outputting the prefix of a log message.
 *  the prefix consists of the logger provider, the log level and the entity id being logged.
 *
 *  @param NSString provider the provider prefix
 *  @param NSString id       the id of the entity being logged
 *  @param NSDictionary<NSString *, id> data     the data to log
 *
 *  @return a preformatted string to be used on the console output
 */
- (NSString *)startFormat:(NSString *)provider id:(NSString *)id data:(NSDictionary<NSString *, id> *)data;

/**
 *  helper to keep things dry
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)dataToString:(NSDictionary<NSString *, id> *)data ;

@end
