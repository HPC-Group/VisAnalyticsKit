//
//  VAKBackendProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 19.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKPersistenceProviderProtocol.h"
#import "VAKRemoteDispatchProtocol.h"
#import "VAKAbstractModel.h"
#import "VAKConstants.h"

/**
 *  A coherent unit that's able to save and find data locally and 
 *  on the other hand can push and pull data to and from remote sources (eg. REST endpoints)
 */
@protocol VAKBackendProtocol <VAKRemoteDispatchProtocol, VAKPersistenceProviderProtocol>

@required

/**
 *  the type of backend possible values @see VAKConstants.h -> VAKBackendTypes
 */
@property(nonatomic, readonly) enum VAKBackendTypes type;

/**
 *  the backend name, that's used to identify a backend in a readable fashion
 */
@property(nonatomic, copy) NSString *name;

/**
 *  a persistence provider instance that has to match the dispatcher given
 */
@property(nonatomic, strong) id<VAKPersistenceProviderProtocol> provider;

/**
 *  in turn a dispatcher instance that has to match the @see provider type given
 */
@property(nonatomic, strong) id<VAKRemoteDispatchProtocol> dispatcher;

// --
#pragma mark methods

/**
 *  Factory method to create a usable backend
 *
 *  @param VAKBackendTypes  a type enum that defines the type of backend
 *  @param id<VAKPersistenceProviderProtocol> provider  a provider protocol instance for example couchbaseLiteProvider
 *  @param id<VAKRemoteDispatchProtocol> dispatcher  a dispatcher protocol instance to be used in conjuction with the given provider
 *
 *  @return id<VAKBackendProtocol> a backend that takes care of saving and finding state locally and also pushes and pulls state from a remote location
 */
+ (instancetype)createWithComponents:(VAKBackendTypes)type
    name:(NSString *)name
    provider:(id<VAKPersistenceProviderProtocol>)provider
    dispatcher:(id<VAKRemoteDispatchProtocol>)dispatcher;

// -

/**
 *  checks whether or not the backend has the necessary components
 *
 *  @return BOOL true if a dispatcher and a persistence provider are available
 */
- (BOOL)isConfigured;

/**
 *  returns the specified backend type
 *
 *  @return VAKBackendTypes
 */
- (VAKBackendTypes)getBackendType;

/**
 *  wrapper for the save:dataToSave: selector
 *
 *  @param VAKAbstractModel domainObject  a arbitrary domainOject that's able to represent itself as a dictionary
 *
 *  @return BOOL if successful
 */
- (BOOL)save:(VAKAbstractModel *)domainObject;

/**
 *  retrieves the storage type of a given backend provider
 *
 *  @return VAKStorageType
 */
- (VAKStorageType)getProviderStorageType;

@end
