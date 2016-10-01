//
//  StateSession.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 22.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import "VAKSession.h"
#import "NSDate+VAKISOFormat.h"
#import "VAKProvSessionFactory.h"
#import "VAKMacros.h"
#import "VAKAliasGenerator.h"

// \cond HIDDEN_SYMBOLS
@interface VAKSession ()

@property(nonatomic, readwrite) NSDate *startTimestamp;
@property(nonatomic, readwrite) NSDate *endTimestamp;
@property(readwrite) NSMutableOrderedSet<id<VAKStateProtocol>> *stateCollection;
@property(readwrite) NSMutableArray<NSString *> *stateIdCollection;
@property(readwrite) BOOL locked;
@property(readwrite, copy) NSString *alias;

@end
// \endcond

// ----------------------------------------
#pragma mark IMPL

@implementation VAKSession

#pragma mark VAKSession Lifecycle

// transformable protocol
+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
    VAKSession *session = [self open];

    [properties enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        if ([key isEqualToString:kVAKSessionStart] || [key isEqualToString:kVAKSessionEnd]) {
          if ([value isKindOfClass:NSString.class]) {
            value = [NSDate vak_dateFromIS08601:value];
          }
        }

        if ([key isEqualToString:kVAKProv]) {
          value = [VAKProv vak_createWithDictionary:value];
        }
      
        if ([session respondsToSelector:NSSelectorFromString(key)]) {
            [session setValue:value forKey:key];
        }
    }];

    session.locked = YES;

    return session;
}

+ (instancetype)open {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _startTimestamp = [NSDate date];
        _locked = NO;
        _stateCollection = [[NSMutableOrderedSet alloc] init];
        _alias = [VAKAliasGenerator generate];
        super.type = kVAKSessionType;
        super.entityId = [self makeId];
        super.useProv = YES;

        return self;
    }

    return nil;
}

- (void)close {
    _endTimestamp = [NSDate date];
    _locked = YES;
}

#pragma mark VAKSession Methods

- (BOOL)hasStates {
    return 0 < [self.stateCollection count];
}

- (NSNumber *)count {
    return @([_stateCollection count]);
}

- (void)batchAddStates:(NSArray<id<VAKStateProtocol>> *)states {
    for (id<VAKStateProtocol> state in states) {
        [_stateCollection addObject:state];
    }
}

- (void)addState:(id<VAKStateProtocol>)state {
    if (!_locked) {
        [_stateCollection addObject:state];
    }
}

- (void)removeState:(id<VAKStateProtocol>)state {
    [_stateCollection removeObject:state];
}

- (NSArray<id<VAKStateProtocol>> *)getStates {
  return [_stateCollection array];
}

- (void)addStateId:(NSString *)stateId {
    if (!_stateIdCollection) {
        _stateIdCollection = [[NSMutableArray alloc] init];
    }
    
    [_stateIdCollection addObject:stateId];
}

- (void)clearStates {
  _stateCollection = nil;
  _stateCollection = [[NSMutableOrderedSet alloc] init];
}

#pragma mark Transformable Protocol API

- (NSDictionary *)vak_objectAsDictionary {
    NSMutableDictionary *sessionDict = [NSMutableDictionary dictionaryWithDictionary:@{
        kVAKSessionStart:[NSDate vak_isoFormatDate:_startTimestamp],
        kVAKStateLogLevel:@(VAKLevelInfo),
        kVAKSessionAlias:_alias,
        kVAKChannels:@[
          kVAKSessionType,
          [[_alias lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"],
          super.entityId
        ]
    }];

    if (_endTimestamp) {
        sessionDict[kVAKSessionEnd] = [NSDate vak_isoFormatDate:_endTimestamp];
    }
    
    if ([_stateIdCollection count] > 0) {
        sessionDict[kVAKSessionStates] = _stateIdCollection;
    }
    
    if (super.useProv) {
        sessionDict[kVAKProv] = [[VAKProvSessionFactory createWithSession:self] vak_objectAsDictionary];
    }

    if (_reason) {
        sessionDict[kVAKSessionReason] = _reason;
    }

    [sessionDict addEntriesFromDictionary:[super vak_objectAsDictionary]];

    return [NSDictionary dictionaryWithDictionary:sessionDict];
}

- (NSString *)makeId {
    NSString *salt = [self.class vak_shortId];

    return VAK_ID(
      @"%@%s%.0f%s%@",
      kVAKSessionIdPrefix,
      kVAKSessionIdDelimiter,
      [_startTimestamp timeIntervalSince1970],
      kVAKSessionIdDelimiter,
      salt
    );
}

@end
