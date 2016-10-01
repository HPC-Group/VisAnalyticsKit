//
//  VAKProvGeneration.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 07.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKProvBase.h"
#import "VAKProvEntity.h"
#import "VAKProvActivity.h"

 /**
  *  this is a representation of a generation relation
  *  https://www.w3.org/TR/prov-dm/#concept-generation
  */
@interface VAKProvGeneration : VAKProvBase

/**
 *  the id of the entity being generated
 */
@property(nonatomic, nonnull, copy) NSString *entity;

/**
 *  the activity that lead to the creation, it can be omitted
 */
@property(nonatomic, nullable, copy) NSString *activity;

/**
 *  the time of the generation
 */
@property(nonatomic, nullable) NSDate *time;

// --

/**
 *  inits the generation with default values
 *
 *  @return VAKProvGeneration
 */
- (_Nonnull instancetype)initWithDefaults;

@end
