//
//  VAKCustomBackend.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 28.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <VisAnalyticsKit/VisAnalyticsKit.h>

/**
 *  a custom backend to be passed in the configuration to facilitate 
 *  none standard pre-configured backends
 */
@interface VAKCustomBackend : VAKBackend

/**
 *  factory method that facades for the createWithComponents in the 
 *  VAKBackendProtocol
 *
 *  @param NSString name  the name of the backend
 *  @param id<VAKPersistenceProviderProtocol> provider  a specific configured persistence provider
 *  @param id<VAKRemoteDispatchProtocol> dispatcher  a specific configured remote dispatcher
 *
 *  @return a usable custom backend to save and dispatch state
 */
+ (instancetype)createWithComponents:(NSString *)name
    provider:(id<VAKPersistenceProviderProtocol>)provider
    dispatcher:(id<VAKRemoteDispatchProtocol>)dispatcher;


@end
