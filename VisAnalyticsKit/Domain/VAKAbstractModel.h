//
//  VAKAbstractModel.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 24.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKPersistableProtocol.h"
#import "VAKTransformableProtocol.h"
#import "VAKProv.h"

 /**
  *  The base model in the framework that implements the ability to be persisted
  *  and some basic serializability.
  */
@interface VAKAbstractModel : NSObject<VAKPersistableProtocol, VAKTransformableProtocol>

/**
 *  should the object use the lineage information?
 */
@property(atomic) BOOL useProv;
/**
 *  the lineage data
 */
@property(atomic) VAKProv *provenance;

#pragma mark METHODS

/**
 * retrieves the delegating provenance agent if provenance was enabled in the first place
 * @return VAKProvDelegatingSoftwareAgent
 */
- (VAKProvDelegatingSoftwareAgent *)getClientInfoFromProv;

@end
