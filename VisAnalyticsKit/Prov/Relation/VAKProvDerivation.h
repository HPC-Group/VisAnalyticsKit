//
//  VAKProvDerivation.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvBase.h"


 /**
  *
  *  A derivation s a transformation of an entity into another, an update of an entity resulting in a 
  *  new one, or the construction of a new entity based on a pre-existing entity.
  *  taken from: https://www.w3.org/TR/prov-dm/#concept-derivation
  */
@interface VAKProvDerivation : VAKProvBase

/**
 *  the newly generated entity
 */
@property(nonatomic, nonnull, copy) NSString *generatedEntity;
/**
 *  the original entity
 */
@property(nonatomic, nonnull, copy) NSString *usedEntity;
/**
 *  the activity that lead to the newly generated entity
 */
@property(nonatomic, nullable, copy) NSString *activity;
/**
 *  the generation process
 */
@property(nonatomic, nullable, copy) NSString *generation;
/**
 *  the usage of the usedEntity
 */
@property(nonatomic, nullable, copy) NSString *usage;

@end
