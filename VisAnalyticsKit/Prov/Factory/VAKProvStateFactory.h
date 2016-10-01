//
//  VAKProvStateFactory.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 22.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKProvFactory.h"
#import "VAKState.h"

/**
 *  responsible for the creation of a provenance aggregate with a state object.
 */
@interface VAKProvStateFactory : VAKProvFactory

/**
 *  factory method that creates a provenance aggregate by passing in a state
 *
 *  @param VAKStateProtocol state  a state object
 *
 *  @return VAKProv a fully configured provenance aggregate
 */
+ (VAKProv *)createWithState:(VAKState *)state;

@end
