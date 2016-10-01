//
//  VAKStateLoggerManager.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 23.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import "VAKLogManager.h"
#import "VAKFileProviderProtocol.h"

// \cond HIDDEN_SYMBOLS
@interface VAKLogManager ()

@property(readwrite) VAKSession *session;
@property(strong, readwrite) NSMutableOrderedSet<id<VAKBackendProtocol>> *backends;
@property(strong, readwrite) NSMutableDictionary<NSString *, id> *backendTypes;

@end
// \endcond

#pragma mark public

@implementation VAKLogManager

+ (instancetype)sharedLogManager {
    static VAKLogManager *manager = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _backends = [[NSMutableOrderedSet alloc] init];
        _backendTypes = [[NSMutableDictionary alloc] init];
        _isRecording = NO;
    }
    
    return self;
}

// -

- (void)startSession {

#if (VAK_LOG_ON == 1)

    if ((![self hasSession] || (_session && [_session isLocked])) && !_isRecording) {
        _session = [VAKSession open];

        [self setPersistentFolder];
        [self persistSession];
    }

#endif
}

- (void)setPersistentFolder {
    for (id<VAKBackendProtocol>backend in _backends) {
        id<VAKPersistenceProviderProtocol> provider = backend.provider;

        BOOL isFileStorage = [backend getProviderStorageType] == VAKStorageFile;
        BOOL isFileBasedProvider = [provider conformsToProtocol:@protocol(VAKFileProviderProtocol)];

        if (isFileStorage && isFileBasedProvider) {
            id<VAKFileProviderProtocol> fileProvider = (id<VAKFileProviderProtocol>)provider;
            [fileProvider addSubfolder:[NSString stringWithFormat:@"%.0f", [_session.startTimestamp timeIntervalSince1970]]];
        }
    }
}

- (BOOL)hasSession {
    return _session != nil;
}

- (void)closeSession {
#if (VAK_LOG_ON == 1)

    if ([self hasSession] && !_session.isLocked && !_isRecording) {
        [_session close];

        [self persistSession];
    }

#endif
}

- (void)persistSession {
#if (VAK_LOG_ON == 1)

    dispatch_async(dispatch_get_main_queue(), ^{
        [_backends enumerateObjectsUsingBlock:^(id<VAKBackendProtocol>backend, NSUInteger idx, BOOL *stop) {
            [backend save:_session];
        }];
    });

#endif
}

- (BOOL)isSessionClosed {
    return _session.isLocked;
}

- (void)recordState:(id<VAKStateProtocol>)state {
#if (VAK_LOG_ON == 1)

    if (!_session && !_isRecording) {
        NSLog(@"%@", kVAKErrorNoSession);
        [self startSession];
    }

    if (!_isRecording) {
        // persist state with the backends
        // using GCD to keep core concerns smooth
        dispatch_async(dispatch_get_main_queue(), ^{
            state.sessionId = _session.entityId;
            [_session addStateId:state.entityId];

            [_backends enumerateObjectsUsingBlock:^(id <VAKBackendProtocol> backend, NSUInteger idx, BOOL *stop) {
                if ([state isKindOfClass:VAKAbstractModel.class]) {
                    [backend save:(VAKAbstractModel <VAKStateProtocol> *) state];
                }
            }];
        });
    }
#endif
}

- (NSNumber *)count {
    return [_session count];
}

#pragma mark Backend

- (NSNumber *)registerBackend:(NSString *)backendType backendInstance:(id<VAKBackendProtocol>)backend {
    NSNumber *registeredAt = @0;
    
    if (![self hasBackendType:backendType]) {
        [_backends addObject:backend];
        NSUInteger index = [_backends indexOfObject:backend];
        registeredAt = @(index);
        [_backendTypes setValue:registeredAt forKey:backendType];
    }
    
    return registeredAt;
}

- (NSNumber *)registerBackend:(id<VAKBackendProtocol>)backend {
    return [self registerBackend:backend.name backendInstance:backend];
}

- (BOOL)deregisterBackend:(NSString *)backendType {
    NSUInteger backendIndex = (NSUInteger) [self.backendTypes[backendType] integerValue];
    BOOL removed = NO;
    
    if (0 <= [@(backendIndex) intValue]) {
        [_backends removeObjectAtIndex:backendIndex];
        [_backendTypes removeObjectForKey:backendType];
        removed = YES;
    }
    
    return removed;
}

- (BOOL)hasBackends {
    return 0 < [_backends count];
}

- (BOOL)hasBackendType:(NSString *)type {
    return _backendTypes[type] != nil;
}

- (NSNumber *)countBackends {
    return @([_backends count]);
}

- (void)clearBackends {
    [_backends removeAllObjects];
    [_backendTypes removeAllObjects];
}

- (NSArray<id<VAKBackendProtocol>> *)getBackendByStorageType:(VAKStorageType)storageType {
    NSMutableArray<id<VAKBackendProtocol>> *returnBackends = [[NSMutableArray alloc] init];

    for (id<VAKBackendProtocol> tmpBackend in _backends) {
        if ([tmpBackend getProviderStorageType] == storageType) {
            [returnBackends addObject:tmpBackend];
        }
    }

    return returnBackends;
}


- (void)push {
    [_backends enumerateObjectsUsingBlock:^(id<VAKBackendProtocol>backend, NSUInteger idx, BOOL *stop) {
        [backend push];
    }];
}

- (id)pull:(NSString *)findId {
    return @"not implemented, yet";
}

// --

- (NSString *)description {
    return [NSString stringWithFormat:@"states in session: %@,\n backendsRegistered: %@\n hasSession: %d and session is closed: %d",
        [self count],
        [self countBackends],
        [self hasSession],
        [self isSessionClosed]
    ];
}

@end
