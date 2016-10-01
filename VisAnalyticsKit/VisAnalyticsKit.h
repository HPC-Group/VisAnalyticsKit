//
//  VisAnalyticsKit.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <UIKit/UIKit.h>

//! Project version number for VisAnalyticsKit.
FOUNDATION_EXPORT double VisAnalyticsKitVersionNumber;

//! Project version string for VisAnalyticsKit.
FOUNDATION_EXPORT const unsigned char VisAnalyticsKitVersionString[];

#pragma mark UTILS

#import <VisAnalyticsKit/VAKConstants.h>
#import <VisAnalyticsKit/VAKMacros.h>

#pragma mark DOMAIN

#import <VisAnalyticsKit/VAKAbstractModel.h>
#import <VisAnalyticsKit/VAKTaggableProtocol.h>
#import <VisAnalyticsKit/VAKTransformableProtocol.h>
#import <VisAnalyticsKit/VAKStateProtocol.h>
#import <VisAnalyticsKit/VAKState.h>
#import <VisAnalyticsKit/VAKStateFactoryProtocol.h>
#import <VisAnalyticsKit/VAKStateFactory.h>
#import <VisAnalyticsKit/VAKSession.h>
#import <VisAnalyticsKit/VAKTouchCollection.h>
#import <VisAnalyticsKit/VAKTouch.h>

#pragma mark SERVICES

// - Manager
#import <VisAnalyticsKit/VAKLogManager.h>
#import <VisAnalyticsKit/VAKLogRegistrationBroker.h>

// - Backend
#import <VisAnalyticsKit/VAKBackendProtocol.h>
#import <VisAnalyticsKit/VAKBackend.h>
#import <VisAnalyticsKit/VAKCustomBackend.h>

// - Builder
#import <VisAnalyticsKit/VAKLogManagerBuilderProtocol.h>
#import <VisAnalyticsKit/VAKDefaultBuilder.h>

// - Filesystem
#import <VisAnalyticsKit/VAKFileReaderProtocol.h>
#import <VisAnalyticsKit/VAKFileWriterProtocol.h>

// - Formatter
#import <VisAnalyticsKit/VAKFormatterProtocol.h>
#import <VisAnalyticsKit/VAKDefaultFormatter.h>
#import <VisAnalyticsKit/VAKMatrixFormatter.h>
#import <VisAnalyticsKit/VAKVectorFormatter.h>

// - Keychain
#import <VisAnalyticsKit/VAKKeychain.h>

// - Network
#import <VisAnalyticsKit/VAKRemoteDispatchProtocol.h>
#import <VisAnalyticsKit/VAKNoopDispatcher.h>

// - Persistence
#import <VisAnalyticsKit/VAKPersistenceProviderProtocol.h>

// - Serializer
#import <VisAnalyticsKit/VAKSerializableProtocol.h>

// -- Console
#import <VisAnalyticsKit/VAKNSLogProvider.h> // Usage is discouraged! Just a POC!!!
#import <VisAnalyticsKit/VAKConsoleProvider.h>

// -- JSON
#import <VisAnalyticsKit/VAKJsonProviderProtocol.h>
#import <VisAnalyticsKit/VAKJsonFileProvider.h>

// EXTENSIONS
#import <VisAnalyticsKit/NSDate+VAKISOFormat.h>
#import <VisAnalyticsKit/NSObject+VAKAspect.h>
#import <VisAnalyticsKit/UITouch+VAKTransformable.h>

// PROV
#import <VisAnalyticsKit/VAKProvBase.h>
#import <VisAnalyticsKit/VAKProvType.h>
#import <VisAnalyticsKit/VAKProv.h>

// -- PROV-FACTORY
#import <VisAnalyticsKit/VAKProvFactory.h>
#import <VisAnalyticsKit/VAKProvSessionFactory.h>
#import <VisAnalyticsKit/VAKProvStateFactory.h>

// -- PROV-RELATION
#import <VisAnalyticsKit/VAKProvAssociation.h>
#import <VisAnalyticsKit/VAKProvAttribution.h>
#import <VisAnalyticsKit/VAKProvDelegation.h>
#import <VisAnalyticsKit/VAKProvDerivation.h>
#import <VisAnalyticsKit/VAKProvGeneration.h>
#import <VisAnalyticsKit/VAKProvRevision.h>
#import <VisAnalyticsKit/VAKProvUsage.h>

// -- PROV-TYPE
#import <VisAnalyticsKit/VAKProvActivity.h>
#import <VisAnalyticsKit/VAKProvDelegatingSoftwareAgent.h>
#import <VisAnalyticsKit/VAKProvEntity.h>
#import <VisAnalyticsKit/VAKProvWritingSoftwareAgent.h>

// -- PROV-UTILS
#import <VisAnalyticsKit/VAKProvKeys.h>

// -----------------------------------------------------------------------------
#pragma mark REPLAY
// -----------------------------------------------------------------------------

// - Controller
#import <VisAnalyticsKit/VAKSourceSelectionViewController.h>

// -- VIEW
#import <VisAnalyticsKit/VAKReplayViewHelper.h>

// - Handlers
//#import <VisAnalyticsKit/VAKReplayTagHandlerProtocol.h>

// - Replay
#import <VisAnalyticsKit/VAKReplayManager.h>
#import <VisAnalyticsKit/VAKInjectableTouchHandlerProtocol.h>
#import <VisAnalyticsKit/VAKStateCustomSelection.h>
