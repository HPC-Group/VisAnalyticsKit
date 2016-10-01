//
//  VAKStateProtocol.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 23.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import "VAKConstants.h"

@class VAKProvDelegatingSoftwareAgent;

/**
 * This protocol defines the base contract all state objects have to oblige to.
 * It's used to keep things loosely coupled in the framework, so developers can
 * implement their own version of a state.
 */
@protocol VAKStateProtocol <NSObject>

@required

/**
 * when did the state occur?
 */
@property(readonly) NSDate *timestamp;
/**
 * state data, e.g. what is logged
 */
@property(atomic) NSDictionary<NSString *, id> *data;
/**
 * The log level of a state, shows importance of the data being logged
 */
@property(atomic) VAKLogLevels level;
/**
 * checks whether a session id has been added
 */
@property(readonly, getter=isLocked) BOOL locked;
/**
 * a comment to give some more semantic meaning to the state, or the situation where it's been captured
 */
@property(atomic, readonly, copy) NSString *comment;
/**
 * sets the app environment to be able to query specific envs out
 */
@property(atomic, readonly) VAKAppEnv environment;
/**
 * sets the ui orientation, defaults to the unknown option
 */
@property(atomic) VAKInterfaceOrientation orientation;
/**
 *  the causer's class name and specific selector, that is responsible for the
 *  the generation of this state
 */
@property(atomic) NSDictionary<NSString *, NSString *> *causer;
/**
 *  the state id 
 */
@property(atomic, copy) NSString *entityId;
/** 
 * The session id a state belongs to. The relationship of those objects is inverted
 * to prevent unnecessary revisions in a couchbase persistence environment.
 * Also the session is just a fancier NSOrdererSet.
 */
@property(atomic, copy) NSString *sessionId;
/**
 *  sets a special id attribute so that one can easily spot a special state in 
 *  a collection
 */
@property(atomic, copy) NSString *specialIDAttribute;

// ----------
#pragma mark METHODS

/**
 * Sets the session id and locks the state
 *
 * @param NSString sessionId
 */
- (void)setSessionId:(NSString *)sessionIdParam;

@end
