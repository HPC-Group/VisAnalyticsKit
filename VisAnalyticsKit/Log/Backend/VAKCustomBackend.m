//
//  VAKCustomBackend.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 28.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKCustomBackend.h"
#import "VAKConstants.h"

@implementation VAKCustomBackend

+ (instancetype)createWithComponents:(NSString *)name
    provider:(id<VAKPersistenceProviderProtocol>)provider
    dispatcher:(id<VAKRemoteDispatchProtocol>)dispatcher {
 
    return [super createWithComponents:VAKBackendCustom name:name provider:provider dispatcher:dispatcher];
}

+ (instancetype)createWithComponents:(VAKBackendTypes)type
    name:(NSString *)name
    provider:(id<VAKPersistenceProviderProtocol>)provider
    dispatcher:(id<VAKRemoteDispatchProtocol>)dispatcher {
    
    return [super createWithComponents:VAKBackendCustom name:name provider:provider dispatcher:dispatcher];
}

@end
