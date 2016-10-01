//
//  VAKPersistableProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 24.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 *  objects that are derived from this protocol are able 
 *  to be persisted and qualify to be named entity
 */
@protocol VAKPersistableProtocol

@required
/**
 *  the domain object type e.g. state, session
 */
@property(atomic, readwrite, copy) NSString *type;

/**
 *  if we were in a rdbms environment this would be called the 
 *  primary key and in DDD it's the legitimation for being called an entity.
 */
@property(atomic, readwrite, copy) NSString *entityId;

@end
