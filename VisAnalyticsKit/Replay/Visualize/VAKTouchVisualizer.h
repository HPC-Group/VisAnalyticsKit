//
// Created by VisAnalyticsKit on 29.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//
// The main parts are taken from here: https://github.com/conopsys/COSTouchVisualizer

#import <UIKit/UIKit.h>

@protocol VAKTouchVisualizerWindowDelegate;

@interface VAKTouchVisualizerWindow : UIWindow

@property (nonatomic, readonly, getter=isActive) BOOL active;
@property (nonatomic, weak) id<VAKTouchVisualizerWindowDelegate> touchVisualizerWindowDelegate;

// Touch effects
@property (nonatomic) UIImage *touchImage;
@property (nonatomic) CGFloat touchAlpha;
@property (nonatomic) NSTimeInterval fadeDuration;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) UIColor *fillColor;

// Ripple Effects
@property (nonatomic) UIImage *rippleImage;
@property (nonatomic) CGFloat rippleAlpha;
@property (nonatomic) NSTimeInterval rippleFadeDuration;
@property (nonatomic) UIColor *rippleStrokeColor;
@property (nonatomic) UIColor *rippleFillColor;

@property (nonatomic) BOOL stationaryMorphEnabled; // default: YES

@end

@protocol VAKTouchVisualizerWindowDelegate <NSObject>

@optional

- (BOOL)touchVisualizerWindowShouldShowFingertip:(VAKTouchVisualizerWindow *)window;
- (BOOL)touchVisualizerWindowShouldAlwaysShowFingertip:(VAKTouchVisualizerWindow *)window;

@end
