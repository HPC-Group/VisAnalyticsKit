//
//  VAKBaseBackend.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 20.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKBackend.h"

// --

// \cond HIDDEN_SYMBOLS
@interface VAKBackend ()

@property(readwrite) enum VAKBackendTypes type;

@end
// \endcond

#pragma mark public

@implementation VAKBackend

@synthesize dispatcher = _dispatcher;
@synthesize provider = _provider;
@synthesize name = _name;
@synthesize storageType = _storageType;

#pragma mark Backend Protocol

+ (instancetype)createWithComponents:(VAKBackendTypes)type
                                name:(NSString *)name
                            provider:(id<VAKPersistenceProviderProtocol>)provider
                          dispatcher:(id<VAKRemoteDispatchProtocol>)dispatcher {
    
    VAKBackend *backend = [[VAKBackend alloc] init];
    
    backend.dispatcher = dispatcher;
    backend.provider = provider;
    backend.type = type;
    backend.name = name;
    
    return backend;
}

- (VAKBackendTypes)getBackendType {
    return _type;
}

// --

- (BOOL)isConfigured {
    return _dispatcher && _provider;
}

- (BOOL)save:(VAKAbstractModel *)domainObject {
    NSDictionary *data = [domainObject vak_objectAsDictionary];
    return [self save:domainObject.entityId dataToSave:data];
}

- (VAKStorageType)getProviderStorageType {
    return _provider.storageType;
}

#pragma mark Provider Protocol

- (BOOL)save:(NSString *)saveId dataToSave:(NSDictionary<NSString *, id> *)dataToSave {
    BOOL success = [_provider save:saveId dataToSave:dataToSave];
    return success;
}

- (NSDictionary<NSString *, id> *)find:(NSString *)retrieveId objectType:(NSString *)type {
    return [_provider find:retrieveId objectType:type];
}

- (NSArray *_Nonnull)findAllSessions:(NSUInteger)limit offset:(NSUInteger)offset {
    return [_provider findAllSessions:limit offset:offset];
}

- (NSNumber *)countSessions {
    return [_provider countSessions];
}

- (NSArray *_Nonnull)findStatesWithSession:(NSString *)sessionId limit:(NSUInteger)limit offset:(NSUInteger)offset {
    return [_provider findStatesWithSession:sessionId limit:limit offset:offset];
}

#pragma mark Dispatcher Protocol

- (id)pull:(NSString *)findId {
    return [_dispatcher pull:findId];
}

- (BOOL)push {
    return [_dispatcher push];
}

@end
