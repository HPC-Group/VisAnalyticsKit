//
//  Constants.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKConstants.h"

// ---------------------
#pragma mark General
// ---------------------

NSString *const kVAKAgentId = @"id";

// ---------------------
#pragma mark Backends
// ---------------------

NSString *const kVAKBackendNSLogNoopName = @"nslog-noop";
NSString *const kVAKBackendConsoleNoopName = @"console-noop";
NSString *const kVAKBackendJsonNoopName = @"Local JSON";

NSString *const kVAKISO_8601 = @"yyyy-MM-dd'T'HH:mm:ss.SSSSZ";

NSString *const kVAKEntityId = @"entityId";
NSString *const kVAKEntityType = @"type";
NSString *const kVAKSessionIdPrefix = @"session";
NSString *const kVAKSessionType = @"session";
char *const kVAKSessionIdDelimiter = "-";
char *const kVAKStateIdDelimiter = "-";

NSString *const kVAKCallerName = @"caller";
NSString *const kVAKMethodCalled = @"methodCalled";
NSString *const kVAKProv = @"provenance";
NSString *const kVAKUseProv = @"useProv";

NSString *const kVAKChannels = @"channels";

// ---------------------
#pragma mark SESSION: Keys
// ---------------------

NSString *const kVAKSessionStart = @"startTimestamp";
NSString *const kVAKSessionEnd = @"endTimestamp" ;
NSString *const kVAKSessionStates = @"stateIdCollection";
NSString *const kVAKSessionReason = @"reason";
NSString *const kVAKSessionAlias = @"alias";
NSString *const kVAKSessionLocked = @"locked";

// ---------------------
#pragma mark STATE: Keys
// ---------------------

NSString *const kVAKStateType = @"state";
NSString *const kVAKStateLogLevel = @"level";
NSString *const kVAKStateSessionId = @"sessionId";
NSString *const kVAKStateData = @"data";
NSString *const kVAKStateIDAttribute = @"specialIDAttribute";
NSString *const kVAKStateDataMatrix = @"matrix";
NSString *const kVAKStateDataVector = @"vector";
NSString *const kVAKStateDataTouches = @"touches";
NSString *const kVAKStateDataFormatter = @"formatter";
NSString *const kVAKSerializerInfo = @"serializer";
NSString *const kVAKSerializerClass = @"serializerClass";
NSString *const kVAKSerializerField = @"serializerField";
NSString *const kVAKStateTimestamp = @"timestamp";
NSString *const kVAKStateComment = @"comment";
NSString *const kVAKStateTags = @"tags";
NSString *const kVAKStateCauser = @"causer";
NSString *const kVAKStateEnvironment = @"environment";
NSString *const kVAKStateOrientation = @"uiOrientation";

// ---------------------
#pragma mark STATE: Values
// ---------------------

NSString *const kVAKStateDefaultTypeValue = @"#default";
NSString *const kVAKUseProvDefaultValue = @"hasProvenance";

// ---------------------
#pragma mark STATE TAGS: VALUES
// ---------------------

NSString *const kVAKTagsViews = @"views";
NSString *const kVAKTagsTouches = @"touches";
NSString *const kVAKTagsKeyframe = @"keyframe";
NSString *const kVAKTagsSettings = @"settings";
NSString *const kVAKTagsEvents = @"events";
NSString *const kVAKTagsUI = @"ui";
NSString *const kVAKTagsCustom = @"custom";

// ---------------------
#pragma mark DSL Logger Config
// ---------------------

NSString *const kVAKConfigViews = @"views";
NSString *const kVAKConfigEvents = @"events";
NSString *const kVAKConfigClass = @"className";
NSString *const kVAKConfigClassContext = @"context";
NSString *const kVAKConfigLogLevel = @"level";
NSString *const kVAKConfigIntercept = @"when";
NSString *const kVAKConfigSelector = @"selector";
NSString *const kVAKConfigTags = @"tags";
NSString *const kVAKConfigInterceptionBlock = @"block";
NSString *const kVAKConfigComment = @"comment";
NSString *const kVAKConfigClient = @"clientInfo";
NSString *const kVAKConfigClientVCS = @"vcs";
NSString *const kVAKConfigClientVCSBranchOrTag = @"vcs_branchOrTag";
NSString *const kVAKConfigClientVCSCommitter = @"vcs_committer";
NSString *const kVAKConfigClientVCSDirty = @"vcs_dirty";
NSString *const kVAKConfigClientVCSOrigin = @"vcs_origin";
NSString *const kVAKConfigClientVCSCommitDate = @"vcs_commitDate";
NSString *const kVAKConfigClientVCSCommitHash = @"vcs_commitHash";

// ---------------------
#pragma mark General Configuration DSL
// ---------------------

NSString *const kVAKConfigWhichBackends = @"whichBackends";
NSString *const kVAKConfigCustomBackends = @"customBackends";
NSString *const kVAKConfigConsoleFieldsWhitelist = @"consoleFieldsWhitelist";
NSString *const kVAKConfigConsoleShowHasProv = @"consoleShowHasProvenance";
NSString *const kVAKConfigConsoleTagsBlacklist = @"consoleTagsBlacklist";
NSString *const kVAKStatesFolderName = @"VisAnalyticsKit";
NSString *const kVAKConfigRegisterSessionLifecycle = @"registerSessionLifeCycle";

// ---------------------
#pragma mark CouchbaseLitePersistenceProvider
// ---------------------

NSString *const kVAKConfigDatabaseName = @"databaseName";
NSString *const kVAKConfigDefaultDatabaseName = @"hpcstatekit";
NSString *const kVAKConfigRemoteAddress = @"remoteAddress";
NSString *const kVAKConfigDefaultRemoteAddress = @"http://hpc.telemetry.dev:4984/sync_gateway/";
NSString *const kVAKConfigUsername = @"username";
NSString *const kVAKConfigDefaultUsername = @"hurley";
NSString *const kVAKConfigUserPassword = @"password";
NSString *const kVAKConfigDefaultUserPassword = @"secret_password";

// ---------------------
#pragma mark Client Information
// ---------------------

NSString *const kVAKConfigClientName = @"client_name";
NSString *const kVAKConfigClientBundle = @"client_bundle";
NSString *const kVAKConfigClientVersion = @"client_version";
NSString *const kVAKConfigClientBuild = @"client_build";
NSString *const kVAKConfigClientId = @"client_id";
NSString *const kVAKConfigClientDeviceType = @"client_deviceType";

// -

NSString *const kVAKNoopDispatcherPullResult = @"noop-result";

// - OS SPECIFICS
#ifdef TARGET_OS_IPHONE
NSString *const kVAKOSName = @"iOS";
#elif defined TARGET_IPHONE_SIMULATOR
NSString *const kVAKOSName = @"simulator";
#elif defined TARGET_OS_MAC
NSString *const kVAKOSName = @"OSX";
#endif

// ---------------------
#pragma mark ERRORS
// ---------------------

NSString *const kVAKErrorNoSession = @" -- VisAnalyticsKit - WARNING: No session was initialized! A session has been started for you";
NSString *const kVAKErrorAutoRegisterLifecyle = @" -- VisAnalyticsKit - WARNING: The automatical registering of the session life cycle failed, because  no valid UIApplication instance was passed.";

// ---------------------
#pragma mark EXTENSIONS
// ---------------------

NSString *const kVAKTouchCurLocation = @"location";
NSString *const kVAKTouchPrevLocation = @"previousLocation";
NSString *const kVAKTouchView = @"view";
NSString *const kVAKTouchWindow = @"window";
NSString *const kVAKTouchTapCount = @"tapCount";
NSString *const kVAKTouchTimestamp = @"relativeTimestamp";
NSString *const kVAKTouchPhase = @"phase";
NSString *const kVAKTouchMajorRadius = @"majorRadius";
NSString *const kVAKTouchMajorRadiusTolerance = @"majorRadiusTolerance";
NSString *const kVAKTouchType = @"type";
NSString *const kVAKTouchForce = @"force";

// ---------------------
#pragma mark EVENTS
// ---------------------

NSString *const onVAKPreReplay = @"onVAKPreReplay";
NSString *const onVAKPostReplay = @"onVAKPostReplay";
NSString *const onVAKClickPlay = @"onVAKClickPlay";
NSString *const onVAKClickCloseReplay = @"onVAKClickCloseReplay";
NSString *const onVAKSessionEnded = @"onVAKSessionEnded";
NSString *const onVAKReplayControllerChanged = @"onVAKReplayControllerChanged";
NSString *const onVAKPullStopped = @"onVAKPullStopped";
NSString *const onVAKPullStarted = @"onVAKPullStarted";
NSString *const onVAKPullStatesStart = @"onVAKPullStatesStart";
NSString *const onVAKPullStatesFinished = @"onVAKPullStatesFinished";
