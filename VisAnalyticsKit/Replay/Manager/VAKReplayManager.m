//
// Created by VisAnalyticsKit on 27.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// CUSTOM
#import "VAKReplayManager.h"
#import "VAKReplayTagHandlerProtocol.h"
#import "VAKReplayTouchTagHandler.h"
#import "VAKStateBaseSelection.h"
#import "VAKStateTouchSelection.h"
#import "VAKStateControllerSelection.h"
#import "VAKStateDoneSelection.h"
#import "VAKStateKeyframeSelection.h"
#import "VAKStateSettingsSelection.h"
#import "VAKDurationCalculator.h"

// \cond HIDDEN_SYMBOLS
@interface VAKReplayManager ()

/**
 * Sets the states to load in one go.
 */
@property(nonatomic) NSUInteger offset;
/**
 * The currently active state position within the session.
 */
@property(nonatomic) NSUInteger currentStateIndex;
/**
 * calculator for duration between states
 */
@property(nonatomic) VAKDurationCalculator *durationCalculator;

@property(nonatomic) NSArray *durations;

@property(nonatomic) BOOL isFirst;

@end
// \endcond

// ----------------------------------------
#pragma mark IMPL


@implementation VAKReplayManager

+ (instancetype)sharedReplayManager {
  static VAKReplayManager *manager = nil;
  static dispatch_once_t once_token;

  dispatch_once(&once_token, ^{
      manager = [[self alloc] init];
      manager.dataRegistry = [[NSMutableDictionary alloc] init];

      // register initial handlers
      manager.handlers = [[NSMutableDictionary alloc] init];
      manager.handlers[kVAKStateDataTouches] = [[VAKReplayTouchTagHandler alloc] init];

  });

  return manager;
}

- (void)fetchStates {
  [self doFetchStates];
  
  if (![_session hasStates]) {
    [self notifyObservers:onVAKPullStatesStart];
    [_backend pull:_session.entityId];

  } else {
    _durations = [self getStateDurations];
  }
};

- (void)doFetchStates {
  NSUInteger offset = [[_session count] unsignedIntegerValue];
  [_session batchAddStates:[_backend findStatesWithSession:_session.entityId limit:50 offset:offset]];
}

- (void)registerPullStoppedAction {
  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(pullStoppedAction)
           name:onVAKPullStopped
         object:nil];
}

- (void)pullStoppedAction {
  [self doFetchStates];

  if ([[_session count] isEqual:@0]) {
    [self fetchStates];

  } else {
    [self notifyObservers:onVAKPullStatesFinished];
  }
}

- (void)replayMode:(BOOL)onOrOff {
  onOrOff ? (VAK_REPLAY_ON()) : (VAK_REPLAY_OFF());
}

- (void)unloadSessionAndBackend {
  _session = nil;
  _backend = nil;
  _isFirst = YES;

  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:onVAKPullStopped
            object:nil];
}

// ---------------------
#pragma mark HANDLERS

- (void)registerTagHandler:(id<VAKReplayTagHandlerProtocol>)handler withTag:(NSString *)tag {
  _handlers[tag] = handler;
}

// ---------------------
#pragma mark HOOKS

- (void)preReplay {
  [self registerPullStoppedAction];
  [self fetchStates];
  [self replayMode:YES];
  _isFirst = YES;
  [self notifyObservers:onVAKPreReplay];
}

- (void)postReplay {
  [self notifyObservers:onVAKPostReplay];
  [self replayMode:NO];

  _currentStateIndex = 0;
  [_session clearStates];
  [self unloadSessionAndBackend];
}

- (void)notifyObservers:(NSString *)eventToPublish {
  [[NSNotificationCenter defaultCenter]
      postNotificationName:eventToPublish
                    object:nil];
}

// ---------------------
#pragma mark REPLAY LOGIC


- (VAKStateBaseSelection * )nextState {
  VAKStateBaseSelection *ret = nil;

  if (_currentStateIndex < [_session getStates].count - 1) {
    ret = [self selectState];

  } else {
    ret = [[VAKStateDoneSelection alloc] init];
  }

  return ret;
}

- (VAKStateBaseSelection *)selectState {
  NSArray<id<VAKStateProtocol>> *states = [_session getStates];
  id<VAKStateProtocol, VAKTaggableProtocol> state = states[_currentStateIndex];
  VAKStateBaseSelection *selection = [[VAKStateDoneSelection alloc] init];

  if ([state hasTag:kVAKTagsTouches]) {
    selection = [[VAKStateTouchSelection alloc] initWithTouches:[_handlers[kVAKStateDataTouches] handleState:state]];
  }

  if ([state hasTag:kVAKTagsViews]) {
    selection = [[VAKStateControllerSelection alloc] initWithController:[self currentViewController:state]];
  }

  if ([state hasTag:kVAKTagsKeyframe]) {
    NSMutableArray *keyframes = [[NSMutableArray alloc] init];
    // we know for sure that the current state is a keyframe
    [keyframes addObject:state];

    selection = [[VAKStateKeyframeSelection alloc] initWithState:keyframes andTagHandlers:_handlers];
  }

  if ([state hasTag:kVAKTagsSettings]) {
    selection = [[VAKStateSettingsSelection alloc] initWithState:state andTagHandlers:_handlers];
  }

  if ([state hasTag:kVAKTagsCustom]) {
    selection = [[VAKStateCustomSelection alloc] initWithState:state andTagHandlers:_handlers];
  }

  _currentStateIndex++;
  _isFirst = NO;

  return selection;
}

- (UIViewController *)currentViewController:(id<VAKStateProtocol, VAKTaggableProtocol>)state {
  Class controllerClass;

  VAKProvDelegatingSoftwareAgent *client = [(VAKAbstractModel *) state getClientInfoFromProv];
  controllerClass = NSClassFromString([client getCallerName]);

  if (!controllerClass) {
    return nil;
  }

  for (UIViewController *controller in _viewControllers) {
    if ([controller isKindOfClass:controllerClass]) {
      [self notifyObserversForControllerChange:controller];

      return controller;
    }
  }
  
  // be sure to handle a controller that is not registered with
  // the replay manager
  return nil;
}


- (NSArray *)getStateDurations {
  if (!_durationCalculator) {
    _durationCalculator = [[VAKDurationCalculator alloc] init];
  }
  
  NSArray *durationForSession = [_durationCalculator calcDurationForSession:_session];

  return durationForSession;
}

- (NSTimeInterval)nextDuration {
  if (_currentStateIndex <= _durations.count - 1 && _durations) {
    return [_durations[_currentStateIndex] doubleValue];
  }

  return 0;
}

- (BOOL)isFirstState {
  return _isFirst;
}

// -----------------------------------------------------------------------
#pragma mark EVENTS

- (void)notifyObserversForControllerChange:(UIViewController *)controller {
  [[NSNotificationCenter defaultCenter]
    postNotificationName:onVAKReplayControllerChanged
                  object:nil
                userInfo:@{@"controller":controller}
  ];
}

@end
