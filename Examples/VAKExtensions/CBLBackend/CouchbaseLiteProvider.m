//
//

// Custom
#import "CouchbaseLiteProvider.h"

// ------------------------------------------------------------------
#pragma mark PRIVATE

@interface CouchbaseLiteProvider ()

@property(strong, nonatomic) CBLView *allSessionsView;
@property(strong, nonatomic) CBLView *countSessionsView;
@property(strong, nonatomic) CBLView *statesBySessionView;
@end

#pragma mark IMPL


@implementation CouchbaseLiteProvider

@synthesize storageType = _storageType;

// ------------------------------------------------------------------
#pragma mark Initializers

+ (instancetype)createWithName:(NSString *)dbName {
  CouchbaseLiteProvider *provider = [[self alloc] init];

  NSError *error;
  provider.database = [[CBLManager sharedInstance] databaseNamed:dbName error:&error];

  if (error) {
    NSLog(@"--- VAKError: Could not open or create database with name %@", dbName);
    NSException *myException = [NSException
      exceptionWithName:@"DatabaseConnectionException"
      reason:[error description]
      userInfo:nil
    ];

    @throw myException;
  }

  return provider;
}

- (instancetype)init {
  self = [super init];

  if (self) {
    _storageType = VAKStorageDatabase;
  }

  return self;
}

#pragma mark PROTOCOL METHODS

- (BOOL)save:(NSString *)saveId dataToSave:(NSDictionary *)dataToSave {
  BOOL saved = YES;

  CBLDocument *doc = [_database documentWithID:saveId];
  NSError *error;

  // we currently don't want states to be mutable
  // so we only handle sessions
  if (dataToSave[kVAKEntityType] == kVAKSessionType && [self find:saveId objectType:kVAKSessionType]) {
    if (![doc update: ^BOOL(CBLUnsavedRevision *newRev) {
      newRev.properties = [dataToSave mutableCopy];
      return YES;

    } error: &error]) {
      saved = NO;
      NSLog(@"--- VAKError: Writing to database failed. ID: %@, data: %@, error: %@", saveId, dataToSave, error.description);
    }

  } else if (![doc putProperties:dataToSave error:&error]) {
    saved = NO;
    NSLog(@"--- VAKError: Writing to database failed. ID: %@, data: %@, error: %@", saveId, dataToSave, error.description);
  }

  return saved;
}

- (NSDictionary *)find:(NSString *)retrieveId objectType:(NSString *)type {
  CBLDocument *doc = [_database documentWithID:retrieveId];

  return doc.properties;
}

- (NSArray * _Nonnull)findAllSessions:(NSUInteger)limit offset:(NSUInteger)offset {
  CBLQuery *query = [_allSessionsView createQuery];
  query.limit = limit;
  query.descending = YES;

  if (offset && offset > 0) {
    query.skip = offset;
  }

  NSError *error;
  CBLQueryEnumerator *result = [query run:&error];

  if (error) {
    NSLog(@" --- VAKError: Query in %@ had an error: %@", NSStringFromSelector(_cmd), error);

    return @[];
  }

  NSMutableArray *results = [[NSMutableArray alloc] init];

  for (CBLQueryRow *row in result) {
    VAKSession *session = [VAKSession vak_createWithDictionary:row.document.properties];
    [results addObject:session];
  }

  return results;
}

- (NSNumber *)countSessions {
  CBLQuery *query = [_countSessionsView createQuery];
  query.groupLevel = 1;
  query.startKey = kVAKSessionType;
  query.endKey = kVAKSessionType;

  NSError *error;
  CBLQueryEnumerator *result = [query run:&error];

  if (error) {
    NSLog(@" --- VAKError: Query in %@ had an error: %@", NSStringFromSelector(_cmd), error);

    return @0;
  }

  return result.count > 0 ? [[result rowAtIndex:0] value] : @0;
}

- (NSArray *_Nonnull)findStatesWithSession:(NSString *)sessionId limit:(NSUInteger)limit offset:(NSUInteger)offset {
  CBLQuery *query = [_statesBySessionView createQuery];
  //query.limit = 1000;
  query.descending = NO;
  query.startKey = sessionId;
  query.endKey = sessionId;

  if (offset && offset > 0) {
    query.skip = offset;
  }

  NSError *error;
  CBLQueryEnumerator *result = [query run:&error];

  if (error) {
    NSLog(@" --- VAKError: Query in %@ had an error: %@", NSStringFromSelector(_cmd), error);

    return @[];
  }

  NSMutableArray *results = [[NSMutableArray alloc] init];
  NSSet *givenTags = [NSSet setWithArray:@[
      kVAKTagsSettings,
      kVAKTagsTouches,
     // kVAKTagsEvents,
     // kVAKTagsUI,
      kVAKTagsKeyframe,
      kVAKTagsViews
  ]];

  for (CBLQueryRow *row in result) {
    VAKState *state = [VAKState vak_createWithDictionary:row.document.properties];
    BOOL intersect = [state.tags intersectsSet:givenTags];

    // information overload => reduce by filtering some of the states
    // we are currently only interested in the givenTags seen above
    if (intersect) {
      [results addObject:state];
      //NSLog(@"state: %@", state);
    }
  }
  
  return results;
}

// ----------------------------------------------------
#pragma mark VIEWS

- (void)createViews {
  [self createAllSessionsView];
  [self createCountSessionsView];
  [self createStatesBySessionView];
}

// ----------------------------------------------------
#pragma mark VIEW MAPPING

- (void)createAllSessionsView {
  _allSessionsView = [_database viewNamed:@"allSessions"];
  _allSessionsView.documentType = kVAKSessionType;

  [_allSessionsView setMapBlock: MAPBLOCK({
      emit(doc[kVAKEntityType], nil);

  }) version: @"2" /* Version of the mapper */ ];
}

- (void)createCountSessionsView {
  _countSessionsView = [_database viewNamed:@"countSessions"];
  _countSessionsView.documentType = kVAKSessionType;

  [_countSessionsView setMapBlock: MAPBLOCK({
    emit(doc[kVAKEntityType], doc[kVAKEntityId]);

  }) reduceBlock:^id(NSArray *keys, NSArray *values, BOOL rereduce) {
    return @(values.count);

  } version: @"3.4"];
}

- (void)createStatesBySessionView {
  _statesBySessionView = [_database viewNamed:@"statesBySession"];
  _statesBySessionView.documentType = kVAKStateType;

  [_statesBySessionView setMapBlock:MAPBLOCK({
      emit(doc[kVAKStateSessionId], doc);

  }) version:@"1.7"];
}

@end
