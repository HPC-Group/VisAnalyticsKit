//
//  VAKCouchbaseLiteDispatcher.h
//

#import <Foundation/Foundation.h>

// External
#import <CouchbaseLite/CouchbaseLite.h>

// Custom
#import <VisAnalyticsKit/VAKRemoteDispatchProtocol.h>

/**
 *  The responsiblilty of the CouchbaseLiteDispatcher is to provide
 *  an interface to a remote Sync Gateway @see http://developer.couchbase.com/documentation/mobile/1.1.0/develop/guides/sync-gateway/index.html
 *  It pushes and pulls data from the remote source.
 */
@interface CouchbaseLiteDispatcher : NSObject<VAKRemoteDispatchProtocol>

/**
 *  the couchbase database to use
 */
@property(strong) CBLDatabase *database;

/**
 *  sets up the push replication to be able to shovel data over to a defined
 *  remote endpoint (sync_gateway)
 */
@property(strong) CBLReplication *pushReplication;

/**
 *  the opposite of the pushReplication. Retrieves data from a remote 
 *  sync_gateway
 */
@property(strong) CBLReplication *pullReplication;

// --

/**
 *  Factory method to create a couchbase lite dispatcher
 *
 *  @param NSDictionary config  a dictionary with the sync gateway address and 
 *                              auth
 *
 *  @return VAKCouchbaseLiteDispatcher  to be used in conjuction with the
 *          CouchbaseLitePersistenceProvider to form a coherent backend
 */
+ (instancetype)createWithDictionary:(NSDictionary *)config;

@end
