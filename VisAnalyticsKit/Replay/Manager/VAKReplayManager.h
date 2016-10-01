//
// Created by VisAnalyticsKit on 27.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// CUSTOM
#import <VisAnalyticsKit/VisAnalyticsKit.h>
#import "VAKStateBaseSelection.h"
@protocol VAKReplayTagHandlerProtocol;

/**
 * The replay manager is responsible for fetching the states to be replayed
 * and handle the replay logic.
 */
@interface VAKReplayManager : NSObject

/**
 * The selected data source to query.
 */
@property(strong, nonatomic) id<VAKBackendProtocol> backend;
/**
 * The session the user is interested in to look at.
 */
@property(strong, nonatomic) VAKSession *session;
/**
 * The items of the root tabbar to be able to iterate through them in a safe way
 */
@property(nonatomic) NSArray<UIViewController *> *viewControllers;
/**
 * The main navigation controller which has references to all the main view controller instances
 */
@property(strong, nonatomic) UITabBarController *rootNavigationController;
/**
 * The background color to be used by the source and session selection view controllers
 */
@property(nonatomic, copy) NSString *backgroundColor;
/**
 * A very naive registry.
 * @see http://martinfowler.com/eaaCatalog/registry.html
 */
@property(strong, nonatomic) NSMutableDictionary *dataRegistry;
/**
 * tag handlers that are responsible of taking care of state with a specific tag
 */
@property(strong, nonatomic) NSMutableDictionary<NSString *, id<VAKReplayTagHandlerProtocol>> *handlers;

// ----------------------------------------
#pragma mark METHODS

/**
 *  Singleton of the replayManager
 *
 *  @return VAKReplayManager a shared instance of the manager
 */
+ (instancetype)sharedReplayManager;

/**
 * This is the actual selector that fetches the states.
 */
- (void)fetchStates;

/**
 * Toggles the replay mode on or off. Internally uses the VAK_REPLAY_ON and VAK_REPLAY_OFF
 * macros.
 */
- (void)replayMode:(BOOL)onOrOff;

// ----------------------------------------
#pragma mark HANDLERS

- (void)registerTagHandler:(id<VAKReplayTagHandlerProtocol>)handler withTag:(NSString *)tag;

// ----------------------------------------
#pragma mark REPLAY LOGIC

/**
 * selects the next state in the session and
 * makes the necessary decisions
 *
 * @return VAKStateBaseSelection a specified response object
 */
- (VAKStateBaseSelection * )nextState;

/**
 * the next duration
 *
 * @return NSTimeInterval
 */
- (NSTimeInterval)nextDuration;

/**
 * has the replay started
 *
 * @return BOOL
 */
- (BOOL)isFirstState;

// ----------------------------------------
#pragma mark HOOKS

/**
 * called when the replayViewController is loaded
 */
- (void)preReplay;

/**
 * called when the replayViewController is unloaded
 */
- (void)postReplay;

@end
