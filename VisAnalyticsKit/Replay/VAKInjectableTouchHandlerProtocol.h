//
// Created by VisAnalyticsKit on 29.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 * Protocol that must be implemented by viewControllers that wants to be able to get touches injected.
 * Touch injection is working but isn't recommended due to probably dangerous side-effects
 */
@protocol VAKInjectableTouchHandlerProtocol <NSObject>

@required

/**
 * Handles the touches began phase
 *
 * @param NSSet touches a set of VAKTouch objects
 */
- (void)vak_handleTouchesBegan:(NSSet *)touches;

/**
 * Handles the moved Phase
 *
 * @param NSSet touches a set of VAKTouch objects
 */
- (void)vak_handleTouchesMoved:(NSSet *)touches;

/**
 * Handles the Ended phase
 *
 * @param NSSet touches a set of VAKTouch objects
 */
- (void)vak_handleTouchesEnded:(NSSet *)touches;

@end
