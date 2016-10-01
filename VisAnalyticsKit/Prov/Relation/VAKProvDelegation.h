//
//  VAKProvDelegation.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvBase.h"

/**
 *  describes a delegation
 *  https://www.w3.org/TR/prov-dm/#concept-delegation
 */
@interface VAKProvDelegation : VAKProvBase

/**
 *  the agent associated with an activity, acting on behalf of the responsible agent
 */
@property(nonatomic, nonnull, copy) NSString *delegate;

/**
 *  the agent, on behalf of which the delegate agent acted
 */
@property(nonatomic, nonnull, copy) NSString *responsible;

/**
 *  an activity for which the delegation link holds
 */
@property(nonatomic, nullable, copy) NSString *activity;

@end
