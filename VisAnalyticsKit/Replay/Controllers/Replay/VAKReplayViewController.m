//
// Created by VisAnalyticsKit on 27.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKReplayViewController.h"
#import "VAKReplayPlayerView.h"
#import "VAKStateBaseSelection.h"
#import "VAKStateTouchSelection.h"
#import "VAKStateControllerSelection.h"
#import "VAKStateKeyframeSelection.h"
#import "VAKStateSettingsSelection.h"
#import "VAKStateCustomSelection.h"

// ----------------------------------------
#pragma mark STATIC

static NSString *const _VAKReplayTabbarStates = @"tabbarStates";

// ----------------------------------------
#pragma mark PRIVATE

// \cond HIDDEN_SYMBOLS
@interface VAKReplayViewController ()

@property(nonatomic) VAKReplayManager *replayManager;
/**
 * The selected view controller that will be added as a child controller
 */
@property(nonatomic) UIViewController *selectedController;
/**
 * Acts as a container for the selected child controller's view, so that the replay controller
 * doesn't have to repaint the whole view everytime the child controller changes.
 */
@property(nonatomic) UIView *selectedViewContainer;

/**
 * the timer that handles the replay
 */
@property(nonatomic) NSTimer *playTimer;

@property(nonatomic) BOOL isPlaying;

@property(nonatomic) VAKReplayPlayerView *player;
@end
// \endcond

// ----------------------------------------
#pragma mark IMPL

@implementation VAKReplayViewController

- (instancetype)init {
  self = [super init];

  if (self) {
    _replayManager = [VAKReplayManager sharedReplayManager];
  }

  return self;
}

// ----------------------------------------
#pragma mark VIEW CONTROLLER CYCLE

- (void)viewDidLoad {
  [self layoutBody];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self resetSettings];
}

- (void)viewWillAppear:(BOOL)animated {
  self.navigationController.navigationBarHidden = YES;

  [self prepareForReplay];
}

// ----------------------------------------
#pragma mark SETTINGS

/**
 * sets the starting viewController and toggles the enabled status of
 * the tabbar to off
 */
- (void)prepareForReplay {
  [_replayManager preReplay];
  [self saveAndDisableTabbarState];
  [self registerPlayerObservers];
  [self setPlayerSessionLabel];
}

- (void)reloadTabbarItemsState {
  UITabBarController *tabbarController = (UITabBarController *)_replayManager.rootNavigationController;
  NSArray *itemStates = _replayManager.dataRegistry[_VAKReplayTabbarStates];

  for (NSUInteger i = 0; i < tabbarController.tabBar.items.count; i++) {
    UITabBarItem *tabbarItem = tabbarController.tabBar.items[i];
    tabbarItem.enabled = [itemStates[i] boolValue];
  }
  
  _replayManager.dataRegistry[_VAKReplayTabbarStates] = nil;

  if (_replayManager.rootNavigationController.tabBar) {
    for (UIView *v  in _replayManager.rootNavigationController.view.subviews) {
      if ([v isKindOfClass:UITabBar.class]) {
        v.alpha = 1;
      }
    }
  }
}

/**
 * toggles the tabbar items' enabled status with the enabled param
 * this needs to be a plugin to truly be modular and handle other types of
 * main navigations els we're left with only tabbed apps
 */
- (void)saveAndDisableTabbarState{
  UITabBarController *tabbarController = (UITabBarController *)_replayManager.rootNavigationController;
  _replayManager.dataRegistry[_VAKReplayTabbarStates] = [[NSMutableArray alloc] init];

  for (UITabBarItem *tabbarItem in tabbarController.tabBar.items) {
    [_replayManager.dataRegistry[_VAKReplayTabbarStates] addObject:@(tabbarItem.enabled)];
    tabbarItem.enabled = NO;
  }
}

/**
 * resets all the hard work we have done so far
 */
- (void)resetSettings {
  [self deregisterPlayerObservers];
  [self removeChildController];
  [self reloadTabbarItemsState];

  _selectedController = nil;
  [_replayManager postReplay];
}

// ----------------------------------------
#pragma mark LAYOUT

- (void)layoutBody {
  // - GENERAL
  UIScreen *mainScreen = [UIScreen mainScreen];

  UIView *cover = [[UIView alloc] initWithFrame:mainScreen.bounds];
  [cover setBackgroundColor:[UIColor clearColor]];
  cover.alpha = .3f;

  // - PLAYER
  CGFloat playerWidth = 400;
  CGFloat playerHeight = 150;
  CGFloat playerX = (mainScreen.bounds.size.width - playerWidth) / 2;
  CGFloat playerY = mainScreen.bounds.size.height - playerHeight - 40;
  CGRect playerRect = CGRectMake(playerX, playerY, playerWidth, playerHeight);

  _player = [[VAKReplayPlayerView alloc] initWithFrame:playerRect];
  [_player setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5f]];
  [self setPlayerSessionLabel];

  // - CHILD VIEW CONTAINER
  _selectedViewContainer = [[UIView alloc] initWithFrame:mainScreen.bounds];

  // - ADD TO VIEW
  [self.view addSubview:_selectedViewContainer];
  [self.view addSubview:cover];
  [self.view addSubview:self.player];
}

- (void)setPlayerSessionLabel {
  _player.sessionLabel.text = _replayManager.session.alias;
}

- (void)injectChildController {
  if (_selectedController) {
    [self addChildViewController:_selectedController];
    [_selectedViewContainer addSubview:_selectedController.view];
  }
}

- (void)removeChildController {
  [_selectedController.view removeFromSuperview];
  [_selectedController removeFromParentViewController];
}

// ----------------------------------------
#pragma mark PLAYER LISTENER

- (void)registerPlayerObservers {
  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(onVAKClickPlay:)
           name:onVAKClickPlay
         object:nil];

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(onVAKClickClose:)
           name:onVAKClickCloseReplay
         object:nil];
}

- (void)deregisterPlayerObservers {
  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:onVAKClickPlay
            object:nil];

  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:onVAKClickCloseReplay
            object:nil];
}

- (void)onVAKClickPlay:(NSNotification *)note {
  if (!_isPlaying) {
    _isPlaying = YES;
    [self play];

  } else {
    [self stopReplay];
  }
}

- (void)stopReplay {
  [_playTimer invalidate];
  _playTimer = nil;
  _isPlaying = NO;
}

- (void)play {
  if (![_replayManager isFirstState]) {
    NSTimeInterval interval = [_replayManager nextDuration];
    NSLog(@"states: %@, interval: %f", [_replayManager.session count], (float) interval);
    /*
     // TIMER ARE Kind of nasty because of their crazy life time
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(handleIncomingState)
                                                userInfo:nil
                                                 repeats:NO];
      */
    if (_isPlaying) {
      [self performSelector:@selector(handleIncomingState) withObject:nil afterDelay:interval];
    }
    
  } else {
    [self handleIncomingState];
  }
}

- (void)handleIncomingState {
  VAKStateBaseSelection *stateSelection = [_replayManager nextState];

  switch (stateSelection.selectionType) {
    case VAKStateDoneSelectionType:
      [self handleDoneSelection];
      break;

    case VAKStateTouchSelectionType:
      NSLog(@"touches");
      // its's best to only visually represent a touch
      // otherwise there might be problems
      // side effects are enormous
      //[self handleTouchSelection:(VAKStateTouchSelection *) stateSelection];
      break;

    case VAKStateControllerSelectionType:
      [self handleControllerSelection:(VAKStateControllerSelection *) stateSelection];
      break;

    case VAKStateKeyframeSelectionType:
      NSLog(@"keyframe");
      [self handleKeyframes:(VAKStateKeyframeSelection *) stateSelection];
      break;

    case VAKStateSettingsSelectionType:
      NSLog(@"settings");
      [self handleSettings:(VAKStateSettingsSelection *) stateSelection];
      break;

    default:
      [self handleCustomSelection:(VAKStateCustomSelection *) stateSelection];
      break;
  }

  [self play];
}

- (void)handleSettings:(VAKStateSettingsSelection *)selection {
  [selection handleSettings];
}

- (void)handleKeyframes:(VAKStateKeyframeSelection *)selection {
  [selection handleKeyframes];
}

- (void)handleControllerSelection:(VAKStateControllerSelection *)selection {
  if (_selectedController) {
    [self removeChildController];
  }
  
  if (selection.selectedController) {
    _selectedController = selection.selectedController;
  }
  
  [self injectChildController];
}

- (void)handleTouchSelection:(VAKStateTouchSelection *)selection {
  if ([_selectedController conformsToProtocol:@protocol(VAKInjectableTouchHandlerProtocol)]) {
    UIViewController<VAKInjectableTouchHandlerProtocol> *touchableViewController;
    touchableViewController = (UIViewController<VAKInjectableTouchHandlerProtocol> *) _selectedController;

    [touchableViewController vak_handleTouchesBegan:[selection.touches getTouchesBeganSet]];
    [_selectedController.view setNeedsDisplay];
    
    NSArray *movedTouches = [selection.touches getTouchesArrayForPhase:UITouchPhaseMoved];

    if ([movedTouches count] > 0) {
      for (NSUInteger i = 0; i < movedTouches.count; i++) {
        [touchableViewController vak_handleTouchesMoved:[NSSet setWithObject:movedTouches[i]]];

        [_selectedController.view setNeedsDisplay];
      }
    }

    [touchableViewController vak_handleTouchesEnded:[selection.touches getTouchesEndedSet]];
    [_selectedController.view setNeedsDisplay];
  }
}

- (void)handleCustomSelection:(VAKStateCustomSelection *)selection {
  [selection handleState];
}

- (void)handleDoneSelection {
  [self stopReplay];

  UIAlertController *alert = [UIAlertController
    alertControllerWithTitle:@"Session ended?"
                     message:@"The session you replayed just ended. Return to session selection?"
              preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *defaultAction = [UIAlertAction
    actionWithTitle:@"Back to selection"
              style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action) {

                [[NSNotificationCenter defaultCenter]
                  postNotificationName:onVAKSessionEnded
                                object:nil];

                [self loadSessionSelectionViewController];
            }];

  UIAlertAction *cancelAction = [UIAlertAction
    actionWithTitle:@"Cancel"
              style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action) {

            }];

  [alert addAction:defaultAction];
  [alert addAction:cancelAction];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)onVAKClickClose:(NSNotification *)note {
  UIAlertController *alert = [UIAlertController
    alertControllerWithTitle:@"Close replay session?"
                     message:@"You are about to close the replay session, proceed?"
              preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *defaultAction = [UIAlertAction
    actionWithTitle:@"Back to selection"
              style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action) {
                [self loadSessionSelectionViewController];
            }];

  UIAlertAction *cancelAction = [UIAlertAction
    actionWithTitle:@"Cancel"
              style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action) {

            }];

  [alert addAction:defaultAction];
  [alert addAction:cancelAction];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadSessionSelectionViewController {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
