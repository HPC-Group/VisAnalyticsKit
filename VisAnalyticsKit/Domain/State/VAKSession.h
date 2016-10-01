//
//  StateSession.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 22.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKStateProtocol.h"
#import "VAKAbstractModel.h"

/**
 * Aggregates multiple states into a more meaningful manner.
 */
@interface VAKSession : VAKAbstractModel

/** the start date of a specific session */
@property(nonatomic, readonly) NSDate *startTimestamp;

/** the end date of the specified session */
@property(nonatomic, readonly) NSDate *endTimestamp;

/** checks whether a session is writeable or not */
@property(readonly, getter=isLocked) BOOL locked;

/** the reason a session was closed */
@property(atomic, copy) NSString *reason;

/** a readable alias for a session */
@property(atomic, readonly, copy) NSString *alias;

@property(nonatomic, readonly) NSUInteger stateCount;


// -----------------------------------------------------------------------------
#pragma mark METHODS

/**
 *  Factory method to be more semantic and to mimic sessions known in other languages
 *
 *  @return StateSession an allocated session
 */
+ (instancetype)open;

/**
 *  closes a specific session and locks it down so no more changes can
 *  be applied. Also sets the end date of the session
 */
- (void)close;

// -----------------------------------------------------------------------------

/**
 *  checks if the session has states
 *
 *  @return BOOL true if states were found
 */
- (BOOL)hasStates;

/**
 *  counts the states saved in the statesCollection
 *
 *  @return NSNumber the states in the stateCollection
 */
- (NSNumber *)count;

/**
 * adds multiple states at once. this is used when states are loaded from a
 * backend and inject into the session
 *
 * @param NSArray<id<VAKStateProtocol>> states  the states to add
 */
- (void)batchAddStates:(NSArray<id<VAKStateProtocol>> *)states;

/**
 *  adds state objects to the state collection
 *
 *  @param id<VAKStateProtocol> a state object
 */
- (void)addState:(id<VAKStateProtocol>)state;

/**
 * removes the given state from the collection
 *
 *  @param id<VAKStateProtocol> the state to be removed from the collection
 */
- (void)removeState:(id<VAKStateProtocol>)state;

/**
 * clears all saved states
 */
- (void)clearStates;

/**
 * retrieves the states in a session
 *
 * @return NSArray<id<VAKStateProtocol>>
 */
- (NSArray<id<VAKStateProtocol>> *)getStates;

/**
 *  adds a state id to a collection to be able to keep track of the 
 *  states in a session
 *
 *  @param NSString stateId a stateId
 */
- (void)addStateId:(NSString *)stateId;

@end
