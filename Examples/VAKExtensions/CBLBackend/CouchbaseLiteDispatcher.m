//
//

// External
#import <CouchbaseLite/CBLManager.h>
#import <CouchbaseLite/CBLAuthenticator.h>

// Custom
#import "CouchbaseLiteDispatcher.h"

@implementation CouchbaseLiteDispatcher

+ (instancetype)createWithDictionary:(NSDictionary *)config {
  CouchbaseLiteDispatcher *dispatcher = [[CouchbaseLiteDispatcher alloc] init];

  [dispatcher initialiseDatabaseWith:config[@"databaseName"]];
  [dispatcher initialiseReplicatorsWith:config];

  return dispatcher;
}

/**
 *  helper to keep factory tidied up
 *  SIDEEFFECTS: sets the database property
 *
 *  @param NSString dbName the database name that should be used to get a db connection
 *  @throws NSException if an error occurs while trying to establish a connection
 */
- (void)initialiseDatabaseWith:(NSString *)dbName {
    NSError *error;

    _database = [[CBLManager sharedInstance] databaseNamed:dbName error:&error];
        
    if (error) {
      NSLog(@"Could not open or create database with name %@", dbName);
      NSException *myException = [NSException
                                    exceptionWithName:@"DatabaseConnectionException"
                                    reason:[error description]
                                    userInfo:nil];
      @throw myException;
    }
}

/**
 *  helper to create replicators and set their authenticator
 *  SIDEEFFECTS: sets push- and pullReplicators and their auth
 *               also sets a default username defined @see VAKConfigDefaultUsername
 *               and a corresponding password if those keys aren't  set.
 *               Also adds observers to watch for changes in the push and pull ops.
 *
 *  @param NSDictionary config the config  passed in.
 *
 */
- (void)initialiseReplicatorsWith:(NSDictionary *)config {
    NSString *remoteAddress = config[@"remoteAddress"];
    
    id<CBLAuthenticator> auth = [CBLAuthenticator basicAuthenticatorWithName:config[@"username"] password:config[@"password"]];
    _pushReplication = [_database createPushReplication:[NSURL URLWithString:remoteAddress]];
    _pullReplication = [_database createPullReplication:[NSURL URLWithString:remoteAddress]];
    
    _pullReplication.authenticator = _pushReplication.authenticator = auth;
    _pushReplication.continuous = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                         selector: @selector(replicationChanged:)
                                             name: kCBLReplicationChangeNotification
                                           object: _pushReplication];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                         selector: @selector(replicationChanged:)
                                             name: kCBLReplicationChangeNotification
                                           object: _pullReplication];
}

/**
 *  checks if the replicationStatus has changed
 *
 *  @param NSNotification a status update notification
 */
- (void)replicationChanged:(NSNotification *)notification {
    // The replication reporting the notification is n.object , but we
    // want to look at the aggregate of both the push and pull.
    
    // First check whether replication is currently active:
    BOOL active = (_pullReplication.status == kCBLReplicationActive) || (_pushReplication.status == kCBLReplicationActive);

    // Now show a progress indicator:
    if (active) {
        double progress = 0.0;
        double total = _pushReplication.changesCount + _pullReplication.changesCount;
        if (total > 0.0) {
            progress = (_pushReplication.completedChangesCount + _pullReplication.completedChangesCount) / total;
        }
        NSLog(@"---- CBL DISPATCH PROGRESS: %f", progress);
    }

    if (_pullReplication.status == kCBLReplicationStopped) {
      [[NSNotificationCenter defaultCenter]
        postNotificationName:onVAKPullStopped
                      object:nil];
    }
}

#pragma mark RemoteDispatcherProtocol

- (id)pull:(NSString *)findId {
    [_pullReplication start];
    _pullReplication.channels = @[findId];

    return @"";
}

- (BOOL)push {
    [_pushReplication start];
    return YES;
}

@end
