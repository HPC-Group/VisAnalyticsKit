//
// Created by VisAnalyticsKit on 10.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * a semantical collection of touches that can be serialized
 */
@interface VAKTouchCollection : NSObject

// -
#pragma mark LifeCycle

/**
 * inits a collection
 */
+ (instancetype)open;

/**
 * closes a collection
 */
- (void)close;

// --
#pragma mark API

- (void)addTouches:(NSArray *)touches;

/**
 * adds the saved touches and deserializes them
 * @param NSArray list  the list of touches
 */
- (void)addTouchesList:(NSArray *)list;

/**
 * retrieves an immutable version of the touch collection at hand
 * @return NSArray<NSArray* >
 */
- (NSArray *)getTouches;

/**
 * counts the touches or touch pairs in the collection
 * @return NSUInteger
 */
- (NSNumber *)count;

/**
 * The following methods all return a specific set of touches in a certain state
 *
 * Returns Touches with Phase UITouchPhaseBegan
 * @return NSSet
 */
- (NSSet *)getTouchesBeganSet;

/**
 * @see getTouchesBeganSet
 * Returns Touches with Phase UITouchPhaseEnded
 */
- (NSSet *)getTouchesEndedSet;
/**
 * @see getTouchesBeganSet
 * Returns Touches with Phase UITouchPhaseMoved
 */
- (NSSet *)getTouchesMovedSet;
/**
 * @see getTouchesBeganSet
 * Returns Touches with Phase UITouchPhaseCancelled
 */
- (NSSet *)getTouchesCancelledSet;
/**
 * adds touches as a unit: TouchPhase = Start opens list,
 * TouchPhase = End || Canceled = close list and add to parent collection
 *
 * @param UITouch touch   the touch to capture
 */
- (void)addTouch:(UITouch *)touch;

- (NSArray *)allObjects;

/**
 * This one is needed to fill in the handleTouchesBegan
 *
 * @return NSSet
 */
- (NSSet *)getSet;

- (NSArray *)getTouchesArrayForPhase:(UITouchPhase)phase;

@end
