//
//  VAKProvActivity.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvType.h"

/**
 *  defines a provenance activity
 *  https://www.w3.org/TR/prov-dm/#term-Activity
 */
@interface VAKProvActivity : VAKProvType

/**
 *  the start of an activity
 */
@property(nonatomic, copy) NSDate *start;
/**
 *  the end of an activity
 */
@property(nonatomic, copy) NSDate *end;

// --

/**
 *  inits the activity with some defaults
 *
 *  @return VAKProvActivity
 */
- (instancetype)initWithDefaults;

@end
