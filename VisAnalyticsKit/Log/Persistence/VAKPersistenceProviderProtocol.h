//
//  VAKPersistenceProviderProtocol.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 14.01.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKConstants.h"

/**
 * Defines a simple interface to be used by all persistence providers.
 * For now it's responsible for finding objects by an identification string and the type
 * of object one is looking for.
 * The other main objection of this is to persist data to a given source.
 */
@protocol VAKPersistenceProviderProtocol <NSObject>

@required

/**
 * sets the specific persistence technology used
 * valid values are given in VAKStorageType
 */
@property(nonatomic, readonly) VAKStorageType storageType;

/**
 * saves a domain object to a persistent source.
 * it is highly dependend where that persistent source is.
 * for example: 
 * if the provider is any kind of a database provider the domain
 * object is saved there but it also could be the filesystem if the persistence provider
 * is of that kind.
 *
 * @param NSDictionary a dictionary seems to be the most appropriate representation of a domain object, 
 * because it's easily transformed to a more desirable different representation
 *
 * @return BOOL if saved without errors
 */
- (BOOL)save:(NSString * _Nonnull)saveId dataToSave:(NSDictionary<NSString *, id> * _Nonnull)dataToSave;


#pragma mark REPOSITORY METHODS

/**
 * find a domain object by a given id and read it in as a dictionary.
 *
 * @param NSString the identification token to look for
 *
 * @param NSString what type of object are we looking for? State or Session. 
 *                  It's possible to be null
 *
 * @return NSDictionary the object as a raw dictionary to be transformed by a service
 */
- (NSDictionary<NSString *, id> * _Nonnull)find:(NSString * _Nonnull)retrieveId objectType:(NSString * _Nullable)type;

/**
 * retrieves all sessions that are found locally. it's possible to limit
 * the retrieved entities and for paging purposes offset the query.
 *
 * @param NSUInteger    limit  how many sessions?
 * @param NSUInteger    offset which page are we on?
 *
 * @return NSArray of objects (the transformation to a VAKSession should be performed in the concrete child)
 */
- (NSArray * _Nonnull)findAllSessions:(NSUInteger)limit offset:(NSUInteger)offset;

/**
 * counts how many sessions are saved
 * @return NSNumber a sum of all sessions found locally
 */
- (NSNumber * _Nonnull)countSessions;

/**
 * retrieves the saved states belonging to a specific session.
 * also has the same options for paging and limiting as the findAllSessions selector
 *
 * @param NSString sessionid  which session are we interested in?
 * @param NSUInteger limit      how many states should we load at once?
 * @param NSUInteger offset     which page are we on?
 */
- (NSArray * _Nonnull)findStatesWithSession:(NSString * _Nonnull)sessionId limit:(NSUInteger)limit offset:(NSUInteger)offset;

@end
