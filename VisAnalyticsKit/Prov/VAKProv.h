//
//  VAKProv.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// - Custom
#import "VAKConstants.h"

// - DSL

#import "VAKProvKeys.h"

// -- RELATIONS

#import "VAKProvAssociation.h"
#import "VAKProvAttribution.h"
#import "VAKProvDelegation.h"
#import "VAKProvGeneration.h"
#import "VAKProvRevision.h"
#import "VAKProvUsage.h"

// -- TYPES

#import "VAKProvActivity.h"
#import "VAKProvEntity.h"
#import "VAKProvDelegatingSoftwareAgent.h"
#import "VAKProvWritingSoftwareAgent.h"

/**
 *  an aggregated provenance model
 */
@interface VAKProv : VAKProvBase

// Custom properties to be passed through to components

/**
 *  keeps track of the ui orientation
 */
@property(nonatomic) VAKInterfaceOrientation uiOrientation;
/**
 *  a dictionary that holds the name of the causing object's class name and
 *  method name 
 */
@property(nonatomic) NSDictionary<NSString *, NSString *> *causer;
/**
 *  this dictionary defines the default prefix used by the prov components
 */
@property(nonatomic) NSDictionary<NSString *, id> *prefix;

#pragma mark Types

/**
 *  @see VAKProvEntity
 */
@property(nonatomic) VAKProvEntity *entity;
/**
 *  @see VAKProvActivity
 */
@property(nonatomic) VAKProvActivity *activity;
/**
 *  @see VAKProvDelegatingSoftwareAgent
 */
@property(nonatomic) VAKProvDelegatingSoftwareAgent *delegatingAgent;
/**
 *  @see VAKProvWritingSoftwareAgent
 */
@property(nonatomic) VAKProvWritingSoftwareAgent *writingAgent;

// --

#pragma mark Relations

/**
 *  @see VAKProvGeneration
 */
@property(nonatomic) VAKProvGeneration *wasGeneratedBy;
/**
 *  @see VAKProvRevision
 */
@property(nonatomic) VAKProvRevision *wasDerivedFrom;
/**
 *  @see VAKProvDelegation
 */
@property(nonatomic) VAKProvDelegation *actedOnBehalfOf;
/**
 *  @see VAKProvAssociation
 */
@property(nonatomic) VAKProvAssociation *wasAssociatedWith;
/**
 *  @see VAKProvAttribution
 */
@property(nonatomic) VAKProvAttribution *wasAttributedTo;
/**
 *  @see VAKProvUsage
 */
@property(nonatomic) VAKProvUsage *used;

@end
