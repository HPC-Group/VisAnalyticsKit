//
//  VAKProvUsage.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvBase.h"

@interface VAKProvUsage : VAKProvBase

/**
 *  the activity being used
 */
@property(nonatomic, nonnull, copy) NSString *activity;

/**
 *  the entity being used
 */
@property(nonatomic, nullable, copy) NSString *entity;

/**
 *  the time of the usage
 */
@property(nonatomic, nullable, copy) NSDate *time;

@end
