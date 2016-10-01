//
// Created by VisAnalyticsKit on 29.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Custom
#import "VAKTransformableProtocol.h"

/**
 * This is basically a wrapper for the UITouch Class that has no public methods to create an instance.
 */
@interface VAKTouch : NSObject<VAKTransformableProtocol>

@property(nonatomic) UITouchType type;
@property(nonatomic) UITouchPhase phase;
@property(nonatomic) NSUInteger tapCount;

@property(nonatomic) NSTimeInterval timestamp;

@property(nonatomic) CGFloat majorRadius;
@property(nonatomic) CGFloat majorRadiusTolerance;
@property(nonatomic) CGFloat force;

@property(nonatomic) NSDictionary *location;
@property(nonatomic) NSDictionary *previousLocation;

@property(nonatomic) Class view;
@property(nonatomic) Class window;

// ---------------------------------------------------
#pragma mark METHODS

/**
 * mimics the locationInView from UITouch
 *
 * @param UIView view  this is actually never used in the implementation
 */
- (CGPoint)locationInView:(nullable UIView *)view;

/**
 * mimics the previousLocationInView from UITouch
 *
 * @param UIView view  this is actually never used in the implementation
 */
- (CGPoint)previousLocationInView:(nullable UIView *)view;


@end
