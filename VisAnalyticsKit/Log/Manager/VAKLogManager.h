//
//  VAKLogManager.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 23.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT


#import <Foundation/Foundation.h>

// CUSTOM
#import "VAKStateProtocol.h"
#import "VAKBackendProtocol.h"
#import "VAKSession.h"
#import "VAKState.h"
#import "VAKConstants.h"
#import "VAKMacros.h"

#pragma mark VAKLogManager

/**
 * Can be described as the core piece of the framework and as such is
 * responsible for managing the state data and the related aggregates like sessions.
 * Also instructs the persistence provider to save data when appropriate, 
 * for example when the app is idle but always in a
 * background thread (dispatch_queue) to not interfere with user experience of 
 * the core concern of an app consuming the framework.
 * Further it's in control of the network dispatch. So the manager decides 
 * when to send data over the network.
 */
@interface VAKLogManager : NSObject

/**
 *  a session that acts as a wrapper for state objects
 *  but is more of a semantical concept
 */
@property(atomic, readonly) VAKSession *session;

/**
 *  sets information about the app that's consuming the framework
 *  this information is necessary for the delegatingSoftwareAgent to 
 *  be able to distinguish between apps
 */
@property(atomic) NSDictionary<NSString *, id> *clientInfo;

@property(nonatomic) BOOL isRecording;

// --------------------------------------------------------------
#pragma mark METHODS
// --------------------------------------------------------------

/**
 *  Singleton of the logManager
 *
 *  @return VAKLogManager a shared instance of the manager
 */
+ (instancetype)sharedLogManager;

// --

/**
 *  starts a session
 */
- (void)startSession;

/**
 *  checks whether or not the manager currently has an initialized session
 *
 *  @return BOOL true if a session was found
 */
- (BOOL)hasSession;

/**
 *  closes the current session
 */
- (void)closeSession;

/**
 *  checks whether or not the current session is closed
 *
 *  @return BOOL true if session is locked
 */
- (BOOL)isSessionClosed;

/**
 *  adds a state to the session.
 *
 *  @param VAKStateProtocol state the specific state to add to the current session
 */
- (void)recordState:(id<VAKStateProtocol>)state;

/**
 *  gets the state count in the current session
 *
 *  @return NSNumber the count of states in the session
 */
- (NSNumber *)count;

#pragma mark Backends

/**
 *  registers backends to be able to save and find data local and remote.
 *  enables the usage of different (backend) channels
 *
 *  @param NSString *const backendType  a key specifing the type of backend to be registered
 *  @param VAKBackendProtocol backend  the backend that serves as a local and remote repository
 *  @return NSNumber the index at which a backend is registered. 0 if a backend is already in the list
 */
- (NSNumber *)registerBackend:(NSString *)backendType backendInstance:(id<VAKBackendProtocol>)backend;

/**
 *  facades the @see registerBackend:backendInstance:
 *
 *  @return @see above
 */
- (NSNumber *)registerBackend:(id<VAKBackendProtocol>)backend;

/**
 *  checks whether or not the manager has backends
 *
 *  @return BOOL true if the manager has a minimum of one backend
 */
- (BOOL)hasBackends;

/**
 *  checks if a specific backendType has been set
 *
 *  @param NSString *const type  the type to lookout for
 *
 *  @return BOOL if the backendType was found
 */
- (BOOL)hasBackendType:(NSString *)type;

/**
 *  removes a backend from the currently employed list of backends
 *
 *  @param NSString the backend type to deregister
 *  @return BOOL true if a backend has been deregistered
 */
- (BOOL)deregisterBackend:(NSString *)backendType;

/**
 *  counts the registered backends
 *
 *  @return NSNumber the registerd backends
 */
- (NSNumber *)countBackends;

/**
 *  clears all registered backends
 */
- (void)clearBackends;

/**
 * retrieves backends that have a certain storage type
 * @param VAKStorageType    storageType of the backend
 * @return NSArray<id<VAKBackendProtocol>>
 */
- (NSArray<id<VAKBackendProtocol>> *)getBackendByStorageType:(VAKStorageType)storageType;

/**
 *  facade for push in VAKRemoteDispatchProtocol
 */
- (void)push;

/**
 *  facade for pull in VAKRemoteDispatchProtocol
 *
 *  @param NSString findId a unique identifier
 *
 *  @return id the desired object or nil
 */
- (id)pull:(NSString *)findId;

@end
