//
//  VAKConstants.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

// Why this way?
// http://stackoverflow.com/questions/538996/constants-in-objective-c?answertab=votes#tab-top

#ifndef VAK_LOG_ON
#define VAK_LOG_ON 1
#endif

// ---------------------
#pragma mark ENUMS
// ---------------------

/**
@file VAKConstants.h
@defgroup _enums Enums
\addtogroup _enums
@{
 */

/**
 * defines the default log levels found in almost all *nix systems
 * @param  NSUInteger
 * @param  VAKLogLevels
 * @return  VAKLogLevels Enum
 */
typedef NS_ENUM(NSUInteger, VAKLogLevels) {
  VAKLevelEmergency   = 0,
  VAKLevelAlert       = 1,
  VAKLevelCritical    = 2,
  VAKLevelError       = 3,
  VAKLevelWarning     = 4,
  VAKLevelNotice      = 5,
  VAKLevelInfo        = 6,
  VAKLevelDebug       = 7
};

/**
 * defines interception points that are mapped in the Aspects.h which are responsible when a specific selector is intercepted
 * @param  NSUInteger
 * @param  VAKInterceptionPoint
 * @return   VAKInterceptionPoint
 */
typedef NS_ENUM(NSUInteger, VAKInterceptionPoint) {
  VAKInterceptAfter = 0,     // AspectPositionAfter
  VAKInterceptInstead = 1,   // AspectPositionInstead
  VAKInterceptBefore = 2    // AspectPositionBefore
};

/**
 * defines which backends are going to be used in the default builder
 * @param  NSUInteger
 * @param  VAKBackendTypes
 * @return  VAKBackendTypes
 */
typedef NS_ENUM(NSUInteger, VAKBackendTypes) {
  VAKBackendNSLogNoop = 0, // Usage discouraged: only use in debug!
  VAKBackendConsoleNoop = 1,
  VAKBackendJsonNoop = 2,
  VAKBackendCustom = 3
};

/**
 *  defines storage types that can be used by a
 *  specific persistence provider
 *  @return VAKStorageType
 */
typedef NS_ENUM(NSUInteger, VAKStorageType) {
  VAKStorageConsole,
  VAKStorageFile,
  VAKStorageDatabase,
  VAKStorageCustom
};

/**
 *  sets the app environment to be used in the state
 *  to filter out some envs in queries
 *  @return VAKAppEnv
 */
typedef NS_ENUM(NSUInteger, VAKAppEnv) {
  VAKAppEnvDebug,
  VAKAppEnvRelease,
  VAKAppEnvCustom
};

/**
 *  wraps apple`s UIInterfaceOrientation 
 */
typedef NS_ENUM(NSInteger, VAKInterfaceOrientation) {
  VAKOrientationUnknown,
  VAKOrientationPortrait,
  VAKOrientationPortraitUpsideDown,
  VAKOrientationLandscapeLeft,
  VAKOrientationLandscapeRight
};


typedef NSDictionary<NSString *, id> VAKSerializer;

/**
Doxygen grouping _enums ends
@}
 */

// ---------------------
#pragma mark GENERAL
// ---------------------

/**
@defgroup _general_keys General Keys Properties
\addtogroup _general_keys
@{
*/

/**
 *  the unique id of this specific agent
 */
FOUNDATION_EXPORT NSString *const kVAKAgentId;

// -- BackendNames

/**
 *  the nslog noop backend's name
 */
FOUNDATION_EXPORT NSString *const kVAKBackendNSLogNoopName;
/**
 *  the name of the default backend
 */
FOUNDATION_EXPORT NSString *const kVAKBackendConsoleNoopName;
/**
 *  the json noop backend's name
 */
FOUNDATION_EXPORT NSString *const kVAKBackendJsonNoopName;
/**
 *  sets the iso 8601 date format
 *  and extends it by adding fractions of seconds
 */
FOUNDATION_EXPORT NSString *const kVAKISO_8601;
/**
 *  sets the id key
 *  value: @"id"
 */
FOUNDATION_EXPORT NSString *const kVAKEntityId;
/**
 *  sets the type key
 *  value: @"type"
 */
FOUNDATION_EXPORT NSString *const kVAKEntityType;
/**
 *  defines the prefix for a sessionId
 *  value: @"hpcsession"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionIdPrefix;
/**
 *  defines a delimiter between @kVAKSessionIdPrefix and the variable sessionIdSuffix
 *  value: @"-"
 */
FOUNDATION_EXPORT char *const kVAKSessionIdDelimiter;
/**
 * Responsible for setting the right type of a state when instantiating a state object via dictionary
 * value: @"session"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionType;

/**
 * Responsible for setting the right type of a state when instantiating a state object via dictionary
 * value: @"state"
 */
FOUNDATION_EXPORT NSString *const kVAKStateType;
/**
 *  defines a delimiter between @kVAKStateIdPrefix and the variable stateIdSuffix
 *  value: @"-"
 */
FOUNDATION_EXPORT char *const kVAKStateIdDelimiter;
/**
 *  sets the name of a caller eg. AppDelegate
 *  value: @"caller"
 */
FOUNDATION_EXPORT NSString *const kVAKCallerName;
/**
 *  sets the method name that's been called
 *  value: @"methodCalled"
 */
FOUNDATION_EXPORT NSString *const kVAKMethodCalled;
/**
 *  sets the provenance key that's used in the hsk models that
 *  implement VAKProvLineageProtocol
 *  value: @"provenance"
 */
FOUNDATION_EXPORT NSString *const kVAKProv;
/**
 *  sets the provenance writing if truthy else disables the provenance writing
 *  value: @"useProv"
 */
FOUNDATION_EXPORT NSString *const kVAKUseProv;
/**
 *  sets the channels key
 *  value: @"channels"
 */
FOUNDATION_EXPORT NSString *const kVAKChannels;

/**
Doxygen grouping  ends
@}
*/

// ---------------------
#pragma mark SESSION: Keys
// ---------------------

/**
@defgroup _session_state_keys Session and State keys
\addtogroup _session_state_keys
@{
*/

/**
 *  the start date of the session
 *  value: @"startTimestamp"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionStart;
/**
 *  the end date of the session
 *  value: @"endTimestamp"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionEnd;
/**
 *  sets a collection of states when initialized by dictionary
 *  value: @"stateCollection"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionStates;
/**
 * sets the reason why a session was closed
 * value: @"reason"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionReason;
/**
 * sets a human readable code name; inspired by the docker engine
 * value: @"alias"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionAlias;
/**
 * sets the locked value
 * value: @"isLocked"
 */
FOUNDATION_EXPORT NSString *const kVAKSessionLocked;

// ---------------------
#pragma mark STATE: Keys
// ---------------------

/**
 * Sets the level key in a dicitionary
 * value: @"level"
 */
FOUNDATION_EXPORT NSString *const kVAKStateLogLevel;
/**
 * Sets the session id key in a dictionary
 * value: @"sessionId"
 */
FOUNDATION_EXPORT NSString *const kVAKStateSessionId;
/**
 * Sets the data key
 * value: @"data"
 */
FOUNDATION_EXPORT NSString *const kVAKStateData;
/**
 * appends a a special id Attribute to the end of the state id
 * value: @"idAttribute"
 */
FOUNDATION_EXPORT NSString *const kVAKStateIDAttribute;
/**
 *  sets the matrix key
 *  value: @"matrix"
 */
FOUNDATION_EXPORT NSString *const kVAKStateDataMatrix;
/**
 *  sets the vector key
 *  value: @"vector"
 */
FOUNDATION_EXPORT NSString *const kVAKStateDataVector;
/**
 * sets the touches key
 * value: @"touches"
 */
FOUNDATION_EXPORT NSString *const kVAKStateDataTouches;
/**
 * sets a specific dataFormatter
 * value: @"formatter"
 */
FOUNDATION_EXPORT NSString *const kVAKStateDataFormatter;
/**
 * sets the serializer to use, this is a VAKSerializer
 * value: @"serializer"
 */
FOUNDATION_EXPORT NSString *const kVAKSerializerInfo;
/**
 * sets the serializer class to use, this has to conform to the
 * VAKSerializableProtocol
 * value: @"serializerClass"
 */
FOUNDATION_EXPORT NSString *const kVAKSerializerClass;
/**
 * sets the field which is the basis of the serialization process
 * value: @"serializerField"
 */
FOUNDATION_EXPORT NSString *const kVAKSerializerField;
/**
 * Sets the timestamp key
 * value: @"timestamp"
 */
FOUNDATION_EXPORT NSString *const kVAKStateTimestamp;
/**
 * Sets the comment key
 * value: @"comment"
 */
FOUNDATION_EXPORT NSString *const kVAKStateComment;
/**
 *  sets the tags key
 *  value: @"tags"
 */
FOUNDATION_EXPORT NSString *const kVAKStateTags;
/**
 *  sets the invoker key that sets the object class and method name
 *  of the perpetrator of a given state.
 *  the value of the key should be a string[]
 *  value: @"causer"
 */
FOUNDATION_EXPORT NSString *const kVAKStateCauser;
/**
 *  in which environment are we currently
 *  value: @"environment"
 */
FOUNDATION_EXPORT NSString *const kVAKStateEnvironment;
/**
 *  sets the ui orientation a particular state has
 *  value: @"uiOrientation"
 */
FOUNDATION_EXPORT NSString *const kVAKStateOrientation;

// - STATE: Values

/**
 * Sets the default type of a state if none is given
 * value: @"#default"
 */
FOUNDATION_EXPORT NSString *const kVAKStateDefaultTypeValue;

/**
 *
 */
FOUNDATION_EXPORT VAKLogLevels *const kVAKStateDefaultLevelValue;
/**
 * sets the provenance value to usesProv, because the information provided is to verbose
 * value: @"uses provenance"
 */
FOUNDATION_EXPORT NSString *const kVAKUseProvDefaultValue;

// ---------------------
#pragma mark STATE TAGS: VALUES
// ---------------------

/**
 * sets the view tag
 * value: @"view"
 */
FOUNDATION_EXPORT NSString *const kVAKTagsViews;
/**
 * sets the touch tag
 * value: @"touches"
 */
FOUNDATION_EXPORT NSString *const kVAKTagsTouches;
/**
 * sets the keyframe tag
 * value: kVAKTagsKeyframe
 */
FOUNDATION_EXPORT NSString *const kVAKTagsKeyframe;
/**
 * sets the settings tag
 * value: @"settings"
 */
FOUNDATION_EXPORT NSString *const kVAKTagsSettings;
/**
 * sets the events tag
 * value: @"events"
 */
FOUNDATION_EXPORT NSString *const kVAKTagsEvents;
/**
 * sets the ui tag
 * value: @"ui"
 */
FOUNDATION_EXPORT NSString *const kVAKTagsUI;
/**
 * sets the custom tag
 * value: @"custom"
 */
FOUNDATION_EXPORT NSString *const kVAKTagsCustom;

/**
Doxygen grouping _session_state_keys ends
@}
 */

// ---------------------
#pragma mark DSL FOR LOGGER CONFIG
// ---------------------

/**
@defgroup _dsl_keys DSL Config Keys
\addtogroup _dsl_keys
 @{
*/

/**
 * Type: Dictionary[] (Root node)
 * The main views dictionary to be used as a root of the views to be logged.
 * The field is required if views should be logged.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigViews;
/**
 * Type: Dictionary[] (Root node)
 * The main events dictionary that forms the root of the events to be logged.
 * Required field if events should be logged.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigEvents;
/**
 * Type: String
 * The class name that should be logged, can either be MyObject.class or @"MyObject".
 * Required field.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClass;
/**
 * Type: Dictionary
 * The context of class that's being logged, holds a dictionary of options.
 * Required field.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClassContext;
/**
 * Type: Integer.
 * A child of VAKClassContext which holds the log level to be used. valid values can be found in @Link: VAKStateProtocol.h
 * Optional. Defaults to VAKLevelInfo.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigLogLevel;
/**
 * Type: Integer.
 * Another child of VAKClassContext that sets the interception point: valid options are defined below in the VAKInterceptionPoint enum.
 * Optional. Defaults to VAKInterceptAfter.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigIntercept;
/**
 * Type: String|Selector
 * Child of VAKClassContext that holds the specific selector to intercept
 * Required field.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigSelector;
/**
 * Type: String[]
 * Child of VAKClassContext that holds a string[] of tag names that define the type of log.
 * Optional.
 */
FOUNDATION_EXPORT NSString *const kVAKConfigTags;
/**
 * Type: Block
 * Child of VAKClassContext. Defines a block that should be executed. The block fires by the definition set in VAKIntercept
 */
FOUNDATION_EXPORT NSString *const kVAKConfigInterceptionBlock;
/**
 * Sets the comment key
 * value: @"comment"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigComment;
/**
 *  sets the clientInfo dictionary
 *  value: @"clientInfo"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClient;
/**
 * optional but quite useful for the replay
 * sets the version control information
 * value: @"vcs"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVCS;
/**
 * sets the branch or tag of the current client
 * value: @"branchOrTag"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVCSBranchOrTag;
/**
 * sets the commiter of the current branch used
 * value: @"committer"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVCSCommitter;
/**
 * checks whether the local repo is dirty
 * value: @"branchOrTag"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVCSDirty;
/**
 * sets the apps origin repository
 * value: @"branchOrTag"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVCSOrigin;
/**
 * sets the commit date of the active commit
 * value: @"commitDate"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVCSCommitDate;
/**
 * the active commit hash being in use
 * value: @"commitHash"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVCSCommitHash;

// ---------------------
#pragma mark General Configuration
// ---------------------

/**
 *  Type: NSArray
 *  A list of VAKBackends (@see above) that defines which of the preconfigured backends to use
 */
FOUNDATION_EXPORT NSString *const kVAKConfigWhichBackends;
/**
 *  Type: VAKBackendProtocol|VAKBackendProtocol[]
 *  defines a single custom backend or an array of custom backends to be used
 */
FOUNDATION_EXPORT NSString *const kVAKConfigCustomBackends;
/**
 *  sets a whiteList of fields that a console provider can consume
 *  if none given, all fields are displayed.
 *  this is a  string[]
 *  value: @"consoleFieldsWhitelist"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigConsoleFieldsWhitelist;
/**
 * enables the console provider to print the hasProvenance key
 * value:@"consoleShowHasProvenance"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigConsoleShowHasProv;
/**
 * blacklists the tags from being displayed on th console
 * value: @"consoleTagsBlacklist"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigConsoleTagsBlacklist;
/**
 *  Type: NSString
 *  sets a default
 */
FOUNDATION_EXPORT NSString *const kVAKConfigFolder;
/**
 * sets the states folder for persistent file-based backends
 * value: @"VisAnalyticsKit"
 */
FOUNDATION_EXPORT NSString *const kVAKStatesFolderName;
/**
 * automatically registers the session life cycle due to the fact that we are using
 * the basic UIApplication loop
 * value: @"registerSessionLifeCycle"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigRegisterSessionLifecycle;

// -
#pragma mark Couchbase settings

/**
 *  Type: NSString
 *  The database name to use when a provider is chosen which needs a database
 *  If the implemented provider is a couchbase type, the value must be all lower
 *  case:
 *  Caution:For compatibility reasons, database names cannot contain uppercase
 *  letters! The only legal characters are lowercase ASCII letters, digits,
 *  and the special characters _$()+-/
 *  http://developer.couchbase.com/documentation/mobile/1.2/develop/guides/couchbase-lite/native-api/database/index.html
 */
FOUNDATION_EXPORT NSString *const kVAKConfigDatabaseName;
/**
 *  Type: NSString
 *  The default database name value
 *  @see VAKConfigDatabaseName
 */
FOUNDATION_EXPORT NSString *const kVAKConfigDefaultDatabaseName;
/**
 *  Type: NSString
 *  remote endpoint address to push to and pull from
 */
FOUNDATION_EXPORT NSString *const kVAKConfigRemoteAddress;
/**
 *  Type: NSString
 *  defaults to the address specified in the sync gateway config
 */
FOUNDATION_EXPORT NSString *const kVAKConfigDefaultRemoteAddress;
/**
 *  Type: NSString
 *  The username to make replication possible
 */
FOUNDATION_EXPORT NSString *const kVAKConfigUsername;
/**
 *  Type: NSString
 *  The default username for the replicators
 *  This corresponds to the user defined in the sync gateway config
 */
FOUNDATION_EXPORT NSString *const kVAKConfigDefaultUsername;
/**
 *  Type: NSString
 *  The password that corresponds the @see VAKConfigUsername
 */
FOUNDATION_EXPORT NSString *const kVAKConfigUserPassword;
/**
 *  Type: NSString
 *  The default password to use. Is set in the sync gateway config
 */
FOUNDATION_EXPORT NSString *const kVAKConfigDefaultUserPassword;
/**
 *  sets the client name that uses the framework
 *  value: @"name"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientName;
/**
 * the bundle identifier
 * value: @"client_bundle"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientBundle;
/**
 *  sets the client version that uses the framework
 *  value: @"version"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientVersion;
/**
 *  the specific build of a consumer
 *  value: @"build"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientBuild;
/**
 *  a client specific id
 *  value: @"id"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientId;
/**
 *  sets the device type of the client
 *  value: @"deviceType"
 */
FOUNDATION_EXPORT NSString *const kVAKConfigClientDeviceType;

/**
Doxygen grouping _dsl ends
@}
 */

/**
@defgroup _other_keys Misc Keys
\addtogroup _other_keys
 @{
*/

/**
 *  sets the return value of a noop dispatcher's pull method
 */
FOUNDATION_EXPORT NSString *const kVAKNoopDispatcherPullResult;

// - OS SPECIFIC

/**
 *  sets the os name specific
 */
FOUNDATION_EXPORT NSString *const kVAKOSName;

/**
Doxygen grouping _other_keys ends
@}
 */

#pragma mark Error Messages

/**
 *  sets the error message if no session has been initialized
 */
FOUNDATION_EXPORT NSString *const kVAKErrorNoSession;
/**
 * if you are using the autoregister session lifecycle and the
 * passed value is not of type UIApplication an error message is shown
 */
FOUNDATION_EXPORT NSString *const kVAKErrorAutoRegisterLifecyle;

// ---------------------
#pragma mark EXTENSIONS
// ---------------------

/**
 *  The current location of a touch in a view
 *  value: @"location"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchCurLocation;
/**
 *  The previous location of a touch in a view
 *  value: @"previousLocation"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchPrevLocation;
/**
 *  The view which is the parent to a touch
 *  value: @"view"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchView;
/**
 * The window in which a touch happend
 * value: @"window"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchWindow;
/**
 * The tap count of a touch
 * value: @"tapCount"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchTapCount;
/**
 * The relative timestamp when a touch occurred
 * value: @"relativeTimestamp"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchTimestamp;
/**
 * The phase a tap is in
 * value: @"phase"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchPhase;
/**
 * The radius (in points) of the touch. (read-only)
 * value: @"majorRadius"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchMajorRadius;
/**
 * The tolerance (in points) of the touch’s radius. (read-only)
 * value: @"majorRadiusTolerance"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchMajorRadiusTolerance;
/**
 * The type of touch received.
 *  value: @"touchType"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchType;
/**
 * The force of the touch, where a value of 1.0 represents the force of an average touch
 * (predetermined by the system, not user-specific). (read-only)
 * value: @"force"
 */
FOUNDATION_EXPORT NSString *const kVAKTouchForce;

// ----------------------------------------
#pragma mark EVENTS
// ----------------------------------------

/**
 * this event is published before the actual replay stuff is happening
 * value: @"onVAKPreReplay"
 */
FOUNDATION_EXPORT NSString *const onVAKPreReplay;
/**
 * event fired when the replay mode is left behind
 * value: @"onVAKPostReplay"
 */
FOUNDATION_EXPORT NSString *const onVAKPostReplay;
/**
 * fired when the player button is clicked
 * value: @"onVAKClickPlay"
 */
FOUNDATION_EXPORT NSString *const onVAKClickPlay;
/**
 * fired when the player wants to close the replay session
 * value: @"onVAKClickCloseReplay"
 */
FOUNDATION_EXPORT NSString *const onVAKClickCloseReplay;
/**
 * fired when the replay session ends
 * value: @"onVAKSessionEnded"
 */
FOUNDATION_EXPORT NSString *const onVAKSessionEnded;
/**
 * fired when the selected viewController changes
 * value: @"onVAKReplayControllerChanged"
 */
FOUNDATION_EXPORT NSString *const onVAKReplayControllerChanged;
/**
 * fired when the pull replication is stopped; has to be implemented by backend dispatcher component
 * value: @"onVAKPullStopped"
 */
FOUNDATION_EXPORT NSString *const onVAKPullStopped;
/**
 * fired when the pulling starts
 * value: @"onVAKPullStarted"
 */
FOUNDATION_EXPORT NSString *const onVAKPullStarted;
/**
 * Fired when a session replay is selected but a session has no states
 * value: @"onVAKPullStatesStart"
 */
FOUNDATION_EXPORT NSString *const onVAKPullStatesStart;
/**
 * Fired when the states have been pulled.
 */
FOUNDATION_EXPORT NSString *const onVAKPullStatesFinished;
