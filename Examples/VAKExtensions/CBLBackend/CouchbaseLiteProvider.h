//

#import <Foundation/Foundation.h>

// External
#import <CouchbaseLite/CouchbaseLite.h>

// Custom
#import <VisAnalyticsKit/VisAnalyticsKit.h>


/**
 *  A persistence provider that conforms to the persistence protocol and 
 *  as such keeps the state and session objects unbound to a particular 
 *  persistence mechanism. 
 *
 *  This provider uses the Couchbase Lite Database for persistence:
 *  More information about Couchbase Lite can be found here:
 *  Repo: https://github.com/couchbase/couchbase-lite-ios
 *  API Overview: http://couchbase.github.io/couchbase-lite-ios/docs/html/annotated.html
 */
@interface CouchbaseLiteProvider : NSObject<VAKPersistenceProviderProtocol>

/**
 *  a database instance that holds the logged states
 */
@property(strong) CBLDatabase *database;

// --

/**
 *  Factory method, that's used to create a usable couchbaseProvider
 *  that keeps the whole framework uncoupled to the Couchbase environment
 *
 *  @param NSString dbName the database to be used @see database property
 *
 *  @return HSKCouchbaseLiteProvider the persistence provider that uses the couchbaseLite database
 *  @throws NSException DatabaseConnectionException when a connection couldn't be established
 */
+ (instancetype)createWithName:(NSString *)dbName;

/**
 * intitializes the necessary views to be able to query the database
 */
- (void)createViews;

@end
