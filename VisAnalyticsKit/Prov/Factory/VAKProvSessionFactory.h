//
//  ProvSessionFactory.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 22.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

//- Custom
#import "VAKProvFactory.h"
#import "VAKSession.h"

/**
 *  creates a provenance aggregate by receiving a session.
 */
@interface VAKProvSessionFactory : VAKProvFactory

/**
 *  factory to create a provenance aggregate from a session
 *
 *  @param VAKStateSessino session the session to use as basis
 *
 *  @return VAKProv the provenance aggregate
 */
+ (VAKProv *)createWithSession:(VAKSession *)session;

@end
