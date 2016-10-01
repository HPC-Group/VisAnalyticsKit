//
//  VAKBaseState.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import "VAKState.h"
#import "VAKMacros.h"
#import "NSDate+VAKISOFormat.h"
#import "VAKProvStateFactory.h"
#import "VAKProv.h"
#import "VAKSerializableProtocol.h"

// \cond HIDDEN_SYMBOLS
@interface VAKState ()

@property(readwrite) NSDate *timestamp;
@property(readwrite) BOOL locked;
@property(readwrite, copy) NSString *comment;
@property(readwrite) VAKAppEnv environment;

@end
// \endcond

// ----------------------------------------
#pragma mark IMPL

@implementation VAKState

@synthesize data = _data;
@synthesize level = _level;
@synthesize locked;
@synthesize sessionId = _sessionId;
@synthesize tags = _tags;
@synthesize comment = _comment;
@synthesize environment = _environment;
@synthesize orientation = _orientation;
@synthesize causer = _causer;
@synthesize specialIDAttribute = _specialIDAttribute;

+ (NSArray *)getStateKeys {
  return @[
      kVAKStateComment,
      kVAKStateTimestamp,
      kVAKEntityType,
      kVAKEntityId,
      kVAKStateData,
      kVAKStateDataFormatter,
      kVAKStateEnvironment,
      kVAKStateCauser,
      kVAKStateTags,
      kVAKStateSessionId,
      kVAKStateLogLevel,
      kVAKProv
  ];
}

// ----------------------------------------
#pragma mark VAKState factory methods

+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
  NSMutableDictionary<NSString *, id> *mutableProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
  [self setDefaultValues:mutableProperties];
  VAKState *state = [self create];

  [mutableProperties enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
    if ([key isEqualToString:kVAKStateEnvironment]) {
      state.environment = (VAKAppEnv) [value integerValue];
      return;
    }
    
    if ([key isEqualToString:kVAKStateTimestamp]) {
        if ([value isKindOfClass:NSString.class]) {
          value = [NSDate vak_dateFromIS08601:value];
        }
    }

    if ([key isEqualToString:kVAKStateTags]) {
        value = [NSMutableOrderedSet orderedSetWithArray:value];
    }

    if ([key isEqualToString:kVAKProv]) {
        value = [VAKProv vak_createWithDictionary:value];
    }

    if ([state respondsToSelector:NSSelectorFromString(key)]) {
      [state setValue:value forKey:key];
    }
  }];

  return state;
}

+ (instancetype)create {
  VAKState *state = [[self alloc] init];

  return state;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _timestamp = [NSDate date];
    _tags = [[NSMutableOrderedSet alloc] init];

    super.type = kVAKStateType;
    super.entityId = [self makeId];
    super.useProv = YES;

#if DEBUG
    _environment = VAKAppEnvDebug;
#elif RELEASE
    _environment = VAKAppEnvRelease;
#else
    _environment = VAKAppEnvCustom;
#endif
  }
  return self;
}

- (void)appendSpecialIDAttribute {
  NSString *enhancedId = super.entityId;

  if (_specialIDAttribute && [enhancedId rangeOfString:@"__"].location == NSNotFound) {
    super.entityId = [NSString stringWithFormat:@"%@__%@", enhancedId, _specialIDAttribute];
  }
}

// ----------------------------------------

/**
 * Helper function to keep things tidy.
 * Sideeffects: Deletes key value pairs that have defaults
 *
 * @param NSMutableDictionary
 */
+ (void)setDefaultValues:(NSMutableDictionary<NSString *, id> *)properties {
  if (!properties[kVAKStateLogLevel]) {
    [properties setValue:@(VAKLevelInfo) forKey:kVAKStateLogLevel];
  }
}

#pragma mark Taggable Protocol API

- (void)addTag:(NSString *)tag {
  if (![self hasTag:tag]) {
    [_tags addObject:tag];
  }
}

- (void)addTags:(NSArray<NSString *> *)tags {
  [tags enumerateObjectsUsingBlock:^(id tag, NSUInteger index, BOOL *stop) {
    [self addTag:tag];
  }];
}

- (BOOL)removeTag:(NSString *)tag {
  BOOL success = NO;

  if ([self hasTag:tag]) {
    [_tags removeObject:tag];
    success = YES;
  }

  return success;
}

- (BOOL)hasTag:(NSString *)tag {
  return [_tags containsObject:tag];
}

- (BOOL)hasTags {
  return 0 < [_tags count];
}

- (BOOL)containsTags:(NSSet *)tagsToLookFor {
  BOOL matches = NO;

  if ([_tags intersectsSet:tagsToLookFor]) {
    matches = YES;
  }

  return matches;
}

// ----------------------------------------
#pragma mark VAKState public api


- (void)setSessionId:(NSString *)sessionIdParam {
  if (!_sessionId && ![self isLocked]) {
    _sessionId = sessionIdParam;
    locked = YES;
  }
}

- (VAKProvDelegatingSoftwareAgent *)getClientInfoFromProv {
  VAKProvDelegatingSoftwareAgent *client = nil;

  if (self.useProv) {
    client = self.provenance.delegatingAgent;
  }

  return client;
}

#pragma mark Transformable Protocol API

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
  NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithDictionary:@{
    kVAKStateLogLevel:@(_level),
    kVAKStateTimestamp:[NSDate vak_isoFormatDate:self.timestamp],
    kVAKStateEnvironment:@(_environment)
  }];
  
  NSMutableArray *channels = [NSMutableArray arrayWithArray:@[kVAKStateType]];
  
  if ([_comment length] > 0) {
    stateDict[kVAKStateComment] = _comment;
  }

  if (_sessionId) {
    stateDict[kVAKStateSessionId] = _sessionId;
    [channels addObject:_sessionId];
  }

  if (_data) {
    stateDict[kVAKStateData] = _data;
  }

  if ([self hasTags]) {
    [stateDict addEntriesFromDictionary:@{kVAKStateTags:[self.tags array]}];
  }

  if (super.useProv) {
    stateDict[kVAKProv] = [[VAKProvStateFactory createWithState:self] vak_objectAsDictionary];
  }
  
  stateDict[kVAKChannels] = channels;
  // mark state as special
  [self appendSpecialIDAttribute];

  [stateDict addEntriesFromDictionary:[super vak_objectAsDictionary]];
  return [NSDictionary dictionaryWithDictionary:stateDict];
}

- (NSString *)makeId {
  // http://stackoverflow.com/a/21208242/406801
  return VAK_ID(
    @"%.0f%s%@",
    [_timestamp timeIntervalSince1970],
    kVAKStateIdDelimiter,
    [self.class vak_shortId]
  );
}

- (NSString *)description {
  NSString *causer = @"";

  if (super.useProv) {
    VAKProvDelegatingSoftwareAgent *delegatingSoftwareAgent = [super getClientInfoFromProv];
    NSDictionary *dict = [delegatingSoftwareAgent getCauser];
    causer = [NSString stringWithFormat:@"[%@ %@]", dict[kVAKCallerName], dict[kVAKMethodCalled]];
  }

  return [NSString stringWithFormat:
    @"%@: stateId:%@, tags: %@, level: %@, causer:%@ data: %@",
      [NSDate vak_isoFormatDate:_timestamp],
      super.entityId,
      _tags,
      @(_level),
      causer,
      _data
  ];
}

@end
