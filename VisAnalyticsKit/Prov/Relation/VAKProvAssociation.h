//
//  VAKProvAssociation.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvBase.h"

/**
 *  an association accoding to 
 *  https://www.w3.org/TR/prov-dm/#concept-association
 */
@interface VAKProvAssociation : VAKProvBase

/**
 *  the activity that has to be associated
 */
@property(nonatomic, nonnull, copy) NSString *activity;

/**
 *  the agent responsible for a use
 */
@property(nonatomic, nullable, copy) NSString *agent;

/**
 *  what is going on
 */
@property(nonatomic, nullable, copy) NSString *plan;

@end
