//
//  ProvFactory.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 22.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// CUSTOM
#import "VAKProv.h"
#import "VAKProvKeys.h"

/**
 *  base class for the different provenance factories. 
 *  this is used to keep things dry.
 */
@interface VAKProvFactory : NSObject

/**
 *  creates the necessary provenance components by passing in a provenance object
 *  that has the entity set
 *
 *  @param VAKProv provenance a provenance aggregate that has the entity set
 *
 *  @return VAKProv the fully configured provenance aggregate
 */
+ (VAKProv *)createComponents:(VAKProv *)prov;

@end
