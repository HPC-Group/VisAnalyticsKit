//
//  VAKProvKeys.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
@file VAKProvKeys.h
@defgroup _provenance  Prov Aggregate
\addtogroup _provenance
@{
 */

// ---------------------
#pragma mark Prov-Aggregate
// ---------------------
/**
 * prefixes the prov concepts
 * value: @"prefix"
 */
FOUNDATION_EXPORT NSString *const kVAKProvPrefix;
/**
 *  an unprefixed key setting the entity used
 *  value: @"entity"
 */
FOUNDATION_EXPORT NSString *const kVAKProvEntity;
/**
 *  an unprefixed key that sets the activity
 *  value: @"activity"
 */
FOUNDATION_EXPORT NSString *const kVAKProvActivity;
/**
 *  an unprefixed key that sets the agent
 *  value: @"agent"
 */
FOUNDATION_EXPORT NSString *const kVAKProvAgent;
/**
 *  an unprefixed key that sets the generation in an aggregate
 *  this is by definition @"wasGeneratedBy"
 */
FOUNDATION_EXPORT NSString *const kVAKProvWasGeneratedBy;
/**
 *  an unprefixed key that sets the derivation in an aggregate
 *  per definition this is @"wasDerivedFrom"
 */
FOUNDATION_EXPORT NSString *const kVAKProvWasDerivedFrom;
/**
 *  an unprefixed key that sets the delegate in an aggregate
 *  by definition this is @"actedOnBehalfOf"
 */
FOUNDATION_EXPORT NSString *const kVAKProvActedOnBehalfOf;
/**
 *  an unprefixed key that sets the association in an aggregate
 *  by def: @"wasAssociatedWith"
 */
FOUNDATION_EXPORT NSString *const kVAKProvWasAssociatedWith;
/**
 *  an unprefixed key that sets the attribution in an aggregate
 *  by def: @"wasAttributedTo"
 */
FOUNDATION_EXPORT NSString *const kVAKProvWasAttributedTo;
/**
 *  an unprefixed key that sets the usage in an aggregate
 *  per definition this is @"used"
 */
FOUNDATION_EXPORT NSString *const kVAKProvUsed;

/**
Doxygen grouping _provenance  ends
@}
 */

/**
@defgroup _provBase Prov Base Keys
\addtogroup _provBase
@{
 */

#pragma mark Prov-Base

/**
 *  sets the start timestamp key (unprefixed)
 *  value: @"start"
 */
FOUNDATION_EXPORT NSString *const kVAKProvStart;
/**
 *  sets the end timestamp key (unprefixed)
 *  value: @"end"
 */
FOUNDATION_EXPORT NSString *const kVAKProvEnd;
/**
 *  sets the time key
 *  value:  @"provenance:time"
 */
FOUNDATION_EXPORT NSString *const kVAKProvTimePrefixed;
/**
 *  sets the activity key
  *  value:  @"provenance:activity"
 */
FOUNDATION_EXPORT NSString *const kVAKProvActivityPrefixed;
/**
 *  sets the entity key
 *  value:  @"provenance:entity"
 */
FOUNDATION_EXPORT NSString *const kVAKProvEntityPrefixed;
/**
 *  sets the agent key
 *  value:  @"provenance:agent"
 */
FOUNDATION_EXPORT NSString *const kVAKProvAgentPrefixed;
/**
 *  sets the plan key
 *  value:  @"provenance:plan"
 */
FOUNDATION_EXPORT NSString *const kVAKProvPlanPrefixed;
/**
 *  sets the delegate key
 *  value:  @"provenance:delegate"
 */
FOUNDATION_EXPORT NSString *const kVAKProvDelegatePrefixed;
/**
 *  sets the responsible key
 *  value:  @"provenance:responsible"
 */
FOUNDATION_EXPORT NSString *const kVAKProvResponsiblePrefixed;
/**
 *  sets the type key for provenance objects
 *  value:  @"provenance:type"
 */
FOUNDATION_EXPORT NSString *const kVAKProvTypePrefixed;
/**
 *  sets the key for a generatedEntity in Derivation
 *  value: @"provenance:generatedEntity"
 */
FOUNDATION_EXPORT NSString *const kVAKProvGeneratedEntityPrefixed;
/**
 *  sets the key for a usedEntity in Derivation
 *  value:  @"provenance:usedEntity"
 */
FOUNDATION_EXPORT NSString *const kVAKProvUsedEntityPrefixed;
/**
 *  sets the key for a generation
 *  value:  @"provenance:generation"
 */
FOUNDATION_EXPORT NSString *const kVAKProvGenerationPrefixed;
/**
 *  sets the key for a generation
 *  value: @"provenance:usage"
 */
FOUNDATION_EXPORT NSString *const kVAKProvUsagePrefixed;

/**
Doxygen grouping _provBase ends
@}
 */

// ---------------------
#pragma mark Attributes
// ---------------------

/**
@defgroup _provAttribs Prov Attributes Keys
\addtogroup _provAttribs
@{
 */

/**
 *  sets os
 *  value: @"os"
 */
FOUNDATION_EXPORT NSString *const kVAKProvOS;
/**
 *  sets os version
 *  value: @"version"
 */
FOUNDATION_EXPORT NSString *const kVAKProvOSVersion;
/**
 *  sets os name
 *  value: @"name"
 */
FOUNDATION_EXPORT NSString *const kVAKProvOSName;
/**
 *  sets the application
 *  value:  @"application"
 */
FOUNDATION_EXPORT NSString *const kVAKProvApplication;
/**
 *  sets the application version
 *  value: @"applicationVersion"
 */
FOUNDATION_EXPORT NSString *const kVAKProvApplicationVersion;
/**
 *  sets label attribute
 *  value: @"provenance:label"
 */
FOUNDATION_EXPORT NSString *const kVAKProvAttributeLabel;
/**
 *  sets the VisAnalyticsKit
 *  value: @"stateKit"
 */
FOUNDATION_EXPORT NSString *const kVAKProvStateKit;
/**
 *  sets the VisAnalyticsKit version
 *  value: @"stateKitVersion"
 */
FOUNDATION_EXPORT NSString *const kVAKProvStateKitVersion;
/**
 * sets the screen info
 * value: @"screenInfo"
 */
FOUNDATION_EXPORT NSString *const kVAKProvScreenInfo;
/**
 *  sets the ui orientation key
 *  value: @"uiOrientation"
 */
FOUNDATION_EXPORT NSString *const kVAKProvUIOrientation;
/**
 * sets the screen width
 * value: @"width"
 */
FOUNDATION_EXPORT NSString *const kVAKProvScreenWidth;
/**
 * sets the screen width
 * value: @"height"
 */
FOUNDATION_EXPORT NSString *const kVAKProvScreenHeight;

// ---------------------
#pragma mark Values
// ---------------------

/**
 *  sets the delimiter for all provenance related ids
 *  value: "-"
 */
FOUNDATION_EXPORT char *const kVAKProvDelimiter;
/**
 *  sets the software agent label
 *  value: @"hskProvAgent"
 */
FOUNDATION_EXPORT NSString *const kVAKProvWritingAgentLabel;
/**
 *  the label to describe the delegating software Agent
 *  value: @"delegatingAgent"
 */
FOUNDATION_EXPORT NSString *const kVAKProvDelegatingSoftwareAgentLabel;

// ---------------------
#pragma mark Types
// ---------------------

/**
 *  sets the software agent type
 *  value: @"provenance:SoftwareAgent"
 */
FOUNDATION_EXPORT NSString *const kVAKProvTypeSoftwareAgent;
/**
 *  sets the revision type
 *  value: @"provenance:Revision"
 */
FOUNDATION_EXPORT NSString *const kVAKProvTypeRevision;

// -- URN

/**
 *  sets the urn namespace that's used in the prefix section of a provenance block
 *  value: @"urn:hpc:""
 */
FOUNDATION_EXPORT NSString *const kVAKProvURNNamspace;

/**
Doxygen grouping _provAttributes  ends
@}
 */
