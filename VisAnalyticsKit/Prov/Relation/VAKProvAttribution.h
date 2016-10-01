//
//  VAKProvAttribution.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvBase.h"

@interface VAKProvAttribution : VAKProvBase
/**
 *  the entity that was attributed
 */
@property(nonatomic, nonnull, copy) NSString *entity;
/**
 *  the agent that changed stuff
 */
@property(nonatomic, nonnull, copy) NSString *agent;

@end
