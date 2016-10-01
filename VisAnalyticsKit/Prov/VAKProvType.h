//
//  VAKProvNode.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKProvKeys.h"
#import "VAKProvBase.h"

 /**
  *  Defines the base node for a provenance
  *  https://www.w3.org/TR/2013/REC-prov-o-20130430/#Entity
  */
@interface VAKProvType : VAKProvBase

/**
 *  sets the type of the node
 *
 *  @param NSString type a specific type to be used
 */
- (void)setType:(NSString *)type;

/**
 *  gets the type node
 *
 *  @return NSString when a type was given nill instead
 */
- (NSString *)getType;

/**
 *  sets a label to name a node
 *
 *  @param NSString label  the label to name the node
 */
- (void)setLabel:(NSString *)label;

/**
 *  gets the specified label
 *
 *  @return NSString the label
 */
- (NSString *)getLabel;

@end
