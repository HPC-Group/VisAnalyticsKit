//
//  VAKProvKeys.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvKeys.h"

#pragma mark Aggregated

NSString *const kVAKProvPrefix = @"prefix";
NSString *const kVAKProvEntity = @"entity";
NSString *const kVAKProvActivity = @"activity";
NSString *const kVAKProvAgent = @"agent";
NSString *const kVAKProvWasGeneratedBy = @"wasGeneratedBy";
NSString *const kVAKProvWasDerivedFrom = @"wasDerivedFrom";
NSString *const kVAKProvActedOnBehalfOf = @"actedOnBehalfOf";
NSString *const kVAKProvWasAssociatedWith = @"wasAssociatedWith";
NSString *const kVAKProvWasAttributedTo = @"wasAttributedTo";
NSString *const kVAKProvUsed = @"used";

#pragma mark Keys

// - PROV-Base
NSString *const kVAKProvEntityPrefixed = @"prov:entity";
NSString *const kVAKProvStart = @"prov:startTime";
NSString *const kVAKProvEnd = @"prov:endTime";
NSString *const kVAKProvTimePrefixed = @"prov:time";
NSString *const kVAKProvActivityPrefixed = @"prov:activity";
NSString *const kVAKProvAgentPrefixed = @"prov:agent";
NSString *const kVAKProvPlanPrefixed = @"prov:plan";
NSString *const kVAKProvDelegatePrefixed = @"prov:delegate";
NSString *const kVAKProvResponsiblePrefixed = @"prov:responsible";
NSString *const kVAKProvTypePrefixed = @"prov:type";
NSString *const kVAKProvGeneratedEntityPrefixed = @"prov:generatedEntity";
NSString *const kVAKProvUsedEntityPrefixed = @"prov:usedEntity";
NSString *const kVAKProvGenerationPrefixed = @"prov:generation";
NSString *const kVAKProvUsagePrefixed = @"prov:usage";

// ---------------------
// -- ATTRIBUTES

NSString *const kVAKProvOS = @"os";
NSString *const kVAKProvOSVersion = @"os_version";
NSString *const kVAKProvOSName = @"os_name";

NSString *const kVAKProvApplication = @"application";
NSString *const kVAKProvApplicationVersion = @"applicationVersion";

NSString *const kVAKProvAttributeLabel = @"prov:label";
NSString *const kVAKProvStateKit = @"stateKit";
NSString *const kVAKProvStateKitVersion = @"stateKitVersion";
NSString *const kVAKProvScreenInfo = @"screenInfo";
NSString *const kVAKProvUIOrientation = @"screen_uiOrientation";
NSString *const kVAKProvScreenWidth = @"screen_width";
NSString *const kVAKProvScreenHeight = @"screen_height";

#pragma mark Values
char *const kVAKProvDelimiter = "-";
NSString *const kVAKProvWritingAgentLabel = @"writingAgent";
NSString *const kVAKProvDelegatingSoftwareAgentLabel = @"delegatingAgent";

#pragma mark types
NSString *const kVAKProvTypeSoftwareAgent = @"prov:SoftwareAgent";
NSString *const kVAKProvTypeRevision = @"prov:Revision";

#pragma mark urn

NSString *const kVAKProvURNNamspace = @"urn:hpc:";
