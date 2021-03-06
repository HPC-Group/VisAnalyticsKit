//
//  VAKTouchVisualizerWindow.m
//  TouchVisualizer
//
//  Created by Joe Blau on 3/22/14.
//  Copyright (c) 2014 conopsys. MIT
//

#import "VAKTouchVisualizer.h"

#pragma mark - Touch Visualizer Window

@interface TouchVisualizerWindow : UIView
@end

@implementation TouchVisualizerWindow

@end

#pragma mark - Touch Spot View

@interface VAKTouchSpotView : UIImageView

@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) BOOL shouldAutomaticallyRemoveAfterTimeout;
@property (nonatomic, getter=isFadingOut) BOOL fadingOut;

@end

@implementation VAKTouchSpotView
@end

#pragma mark - Touch Visualizer Window

@interface VAKTouchVisualizerWindow ()

@property (nonatomic) UIView *overlayWindow;
@property (nonatomic) UIViewController *overlayWindowViewController;
@property (nonatomic) BOOL fingerTipRemovalScheduled;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSSet *allTouches;

- (void)VAKTouchVisualizerWindow_commonInit;
- (void)scheduleFingerTipRemoval;
- (void)cancelScheduledFingerTipRemoval;
- (void)removeInactiveFingerTips;
- (void)removeFingerTipWithHash:(NSUInteger)hash animated:(BOOL)animated;
- (BOOL)shouldAutomaticallyRemoveFingerTipForTouch:(UITouch *)touch;

@end

@implementation VAKTouchVisualizerWindow

- (id)initWithCoder:(NSCoder *)decoder {
  // This covers NIB-loaded windows.
  if (self = [super initWithCoder:decoder])
    [self VAKTouchVisualizerWindow_commonInit];
  return self;
}

- (id)initWithFrame:(CGRect)rect {
  // This covers programmatically-created windows.
  if (self = [super initWithFrame:rect])
    [self VAKTouchVisualizerWindow_commonInit];
  return self;
}

- (void)VAKTouchVisualizerWindow_commonInit {
  self.strokeColor = [UIColor blackColor];
  self.fillColor = [UIColor whiteColor];
  self.rippleStrokeColor = [UIColor whiteColor];
  self.rippleFillColor = [UIColor blueColor];
  self.touchAlpha = 0.5;
  self.fadeDuration = 0.3;
  self.rippleAlpha = 0.2;
  self.rippleFadeDuration = 0.2;
  self.stationaryMorphEnabled = YES;
}

#pragma mark - Touch / Ripple and Images

- (UIImage *)touchImage {
  if (!_touchImage) {
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 50.0, 50.0)];

    UIGraphicsBeginImageContextWithOptions(clipPath.bounds.size, NO, 0);

    UIBezierPath *drawPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25.0, 25.0)
                                                            radius:22.0
                                                        startAngle:0
                                                          endAngle:2 * M_PI
                                                         clockwise:YES];

    drawPath.lineWidth = 2.0;

    [self.strokeColor setStroke];
    [self.fillColor setFill];

    [drawPath stroke];
    [drawPath fill];

    [clipPath addClip];

    _touchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  return _touchImage;
}

- (UIImage *)rippleImage {
  if (!_rippleImage) {
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 50.0, 50.0)];

    UIGraphicsBeginImageContextWithOptions(clipPath.bounds.size, NO, 0);

    UIBezierPath *drawPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25.0, 25.0)
                                                            radius:22.0
                                                        startAngle:0
                                                          endAngle:2 * M_PI
                                                         clockwise:YES];

    drawPath.lineWidth = 2.0;

    [self.rippleStrokeColor setStroke];
    [self.rippleFillColor setFill];

    [drawPath stroke];
    [drawPath fill];

    [clipPath addClip];

    _rippleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  return _rippleImage;
}

#pragma mark - Active

- (BOOL)anyScreenIsMirrored {
  if (![UIScreen instancesRespondToSelector:@selector(mirroredScreen)])
    return NO;

  for (UIScreen *screen in [UIScreen screens]) {
    if ([screen mirroredScreen] != nil) {
      return YES;
    }
  }
  return NO;
}

- (BOOL)isActive {
  // should show fingertip or not
  if (![self.touchVisualizerWindowDelegate respondsToSelector:@selector(touchVisualizerWindowShouldShowFingertip:)] ||
    [self.touchVisualizerWindowDelegate touchVisualizerWindowShouldShowFingertip:self]) {
    // should always show or only when any screen is mirrored.
    return (([self.touchVisualizerWindowDelegate respondsToSelector:@selector(touchVisualizerWindowShouldAlwaysShowFingertip:)] &&
      [self.touchVisualizerWindowDelegate touchVisualizerWindowShouldAlwaysShowFingertip:self]) ||
      [self anyScreenIsMirrored]);
  } else {
    return NO;
  }
}

#pragma mark - UIWindow overrides

- (void)sendEvent:(UIEvent *)event {
  if (self.active) {
    self.allTouches = [event allTouches];
    for (UITouch *touch in [self.allTouches allObjects]) {
      switch (touch.phase) {
        case UITouchPhaseBegan:
        case UITouchPhaseMoved: {
          // Generate ripples
          VAKTouchSpotView *rippleView = [[VAKTouchSpotView alloc] initWithImage:self.rippleImage];
          [self.overlayWindow addSubview:rippleView];

          rippleView.alpha = self.rippleAlpha;
          rippleView.center = [touch locationInView:self.overlayWindow];

          [UIView animateWithDuration:self.rippleFadeDuration
                                delay:0.0
                              options:UIViewAnimationOptionCurveEaseIn // See other
            // options
                           animations:^{
                               [rippleView setAlpha:0.0];
                               [rippleView setFrame:CGRectInset(rippleView.frame, 25, 25)];
                           } completion:^(BOOL finished) {
                [rippleView removeFromSuperview];
            }];
        }
        case UITouchPhaseStationary: {
          VAKTouchSpotView *touchView = (VAKTouchSpotView *)[self.overlayWindow viewWithTag:touch.hash];

          if (touch.phase != UITouchPhaseStationary && touchView != nil && [touchView isFadingOut]) {
            [self.timer invalidate];
            [touchView removeFromSuperview];
            touchView = nil;
          }

          if (touchView == nil && touch.phase != UITouchPhaseStationary) {
            touchView = [[VAKTouchSpotView alloc] initWithImage:self.touchImage];
            [self.overlayWindow addSubview:touchView];

            if (self.stationaryMorphEnabled) {
              self.timer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                            target:self
                                                          selector:@selector(performMorph:)
                                                          userInfo:touchView
                                                           repeats:YES];
            }
          }
          if (![touchView isFadingOut]) {
            touchView.alpha = self.touchAlpha;
            touchView.center = [touch locationInView:self.overlayWindow];
            touchView.tag = touch.hash;
            touchView.timestamp = touch.timestamp;
            touchView.shouldAutomaticallyRemoveAfterTimeout = [self shouldAutomaticallyRemoveFingerTipForTouch:touch];
          }
          break;
        }
        case UITouchPhaseEnded:
        case UITouchPhaseCancelled: {
          [self removeFingerTipWithHash:touch.hash animated:YES];
          break;
        }
      }
    }
  }

  [super sendEvent:event];
  [self scheduleFingerTipRemoval];    // We may not see all UITouchPhaseEnded/UITouchPhaseCancelled events.
}

#pragma mark - Private

- (UIView *)overlayWindow {
  if (!_overlayWindow) {
    _overlayWindow = [[TouchVisualizerWindow alloc] initWithFrame:self.frame];
    _overlayWindow.userInteractionEnabled = NO;
    //_overlayWindow.windowLevel = UIWindowLevelStatusBar;
    _overlayWindow.backgroundColor = [UIColor clearColor];
    _overlayWindow.hidden = NO;
  }
  return _overlayWindow;
}

- (void)scheduleFingerTipRemoval {

  if (self.fingerTipRemovalScheduled)
    return;
  self.fingerTipRemovalScheduled = YES;
  [self performSelector:@selector(removeInactiveFingerTips)
             withObject:nil
             afterDelay:0.1];
}

- (void)cancelScheduledFingerTipRemoval {
  self.fingerTipRemovalScheduled = YES;
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(removeInactiveFingerTips)
                                             object:nil];
}

- (void)removeInactiveFingerTips {
  self.fingerTipRemovalScheduled = NO;

  NSTimeInterval now = [[NSProcessInfo processInfo] systemUptime];
  const CGFloat REMOVAL_DELAY = 0.2;
  for (VAKTouchSpotView *touchView in [self.overlayWindow subviews]) {
    if (![touchView isKindOfClass:[VAKTouchSpotView class]])
      continue;

    if (touchView.shouldAutomaticallyRemoveAfterTimeout && now > touchView.timestamp + REMOVAL_DELAY)
      [self removeFingerTipWithHash:touchView.tag animated:YES];
  }

  if ([[self.overlayWindow subviews] count])
    [self scheduleFingerTipRemoval];
}

- (void)removeFingerTipWithHash:(NSUInteger)hash animated:(BOOL)animated {
  VAKTouchSpotView *touchView = (VAKTouchSpotView *)[self.overlayWindow viewWithTag:hash];
  if (touchView == nil)
    return;

  if ([touchView isFadingOut])
    return;

  BOOL animationsWereEnabled = [UIView areAnimationsEnabled];

  if (animated) {
    [UIView setAnimationsEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.fadeDuration];
  }

  touchView.frame = CGRectMake(touchView.center.x - touchView.frame.size.width,
    touchView.center.y - touchView.frame.size.height,
    touchView.frame.size.width * 2, touchView.frame.size.height * 2);

  touchView.alpha = 0.0;

  if (animated) {
    [UIView commitAnimations];
    [UIView setAnimationsEnabled:animationsWereEnabled];
  }

  touchView.fadingOut = YES;
  [touchView performSelector:@selector(removeFromSuperview)
                  withObject:nil
                  afterDelay:self.fadeDuration];
}

- (BOOL)shouldAutomaticallyRemoveFingerTipForTouch:(UITouch *)touch;
{
  // We don't reliably get UITouchPhaseEnded or UITouchPhaseCancelled
  // events via -sendEvent: for certain touch events. Known cases
  // include swipe-to-delete on a table view row, and tap-to-cancel
  // swipe to delete. We automatically remove their associated
  // fingertips after a suitable timeout.
  //
  // It would be much nicer if we could remove all touch events after
  // a suitable time out, but then we'll prematurely remove touch and
  // hold events that are picked up by gesture recognizers (since we
  // don't use UITouchPhaseStationary touches for those. *sigh*). So we
  // end up with this more complicated setup.

  UIView *view = [touch view];
  view = [view hitTest:[touch locationInView:view] withEvent:nil];

  while (view != nil) {
    if ([view isKindOfClass:[UITableViewCell class]]) {
      for (UIGestureRecognizer *recognizer in [touch gestureRecognizers]) {
        if ([recognizer isKindOfClass:[UISwipeGestureRecognizer class]])
          return YES;
      }
    }

    if ([view isKindOfClass:[UITableView class]]) {
      if ([[touch gestureRecognizers] count] == 0)
        return YES;
    }
    view = view.superview;
  }

  return NO;
}

- (void)performMorph:(NSTimer *)theTimer {
  UIView *view = (UIView *)[theTimer userInfo];
  NSTimeInterval duration = .4;
  NSTimeInterval delay = 0;
  // Start
  view.alpha = self.touchAlpha;
  view.transform = CGAffineTransformMakeScale(1, 1);
  [UIView animateWithDuration:duration / 4
                        delay:delay
                      options:0
                   animations:^{
                       // End
                       view.transform = CGAffineTransformMakeScale(1, 1.2);
                   }
                   completion:^(BOOL finished) {
                       [UIView animateWithDuration:duration / 4
                                             delay:0
                                           options:0
                                        animations:^{
                                            // End
                                            view.transform = CGAffineTransformMakeScale(1.2, 0.9);
                                        }
                                        completion:^(BOOL finished) {
                                            [UIView animateWithDuration:duration / 4
                                                                  delay:0
                                                                options:0
                                                             animations:^{
                                                                 // End
                                                                 view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                                             }
                                                             completion:^(BOOL finished) {
                                                                 [UIView animateWithDuration:duration / 4
                                                                                       delay:0
                                                                                     options:0
                                                                                  animations:^{
                                                                                      // End
                                                                                      view.transform = CGAffineTransformMakeScale(1, 1);
                                                                                  }
                                                                                  completion:^(BOOL finished){
                                                                                      // If there are no touches, remove this morping touch
                                                                                      if (self.allTouches.count == 0)
                                                                                        [view removeFromSuperview];
                                                                                  }];
                                                             }];
                                        }];
                   }];
}

@end
