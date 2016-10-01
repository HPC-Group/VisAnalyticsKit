//
//  UITouch+Transformable.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.04.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "UITouch+VAKTransformable.h"
#import "VAKConstants.h"

@implementation UITouch (VAKTransformable)

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary *touchDict = [[NSMutableDictionary alloc] init];
    
    // just for safety reasons: otherwise we could crash the app
    @try {
        [touchDict addEntriesFromDictionary:@{
            kVAKTouchPhase:@(self.phase),
            kVAKTouchTapCount:@(self.tapCount),
            kVAKTouchCurLocation:(__bridge id) CGPointCreateDictionaryRepresentation([self locationInView:self.view]),
            kVAKTouchPrevLocation:(__bridge id) CGPointCreateDictionaryRepresentation([self previousLocationInView:self.view]),
            kVAKTouchWindow:NSStringFromClass(self.window.class),
            kVAKTouchTimestamp:[NSString stringWithFormat:@"%f", self.timestamp],
            kVAKTouchMajorRadius:@(self.majorRadius),
            kVAKTouchMajorRadiusTolerance:@(self.majorRadiusTolerance),
            kVAKTouchType:@(self.type),
            kVAKTouchForce:@(self.force)
        }];
        
        // it seems that not every touch has a view.class so we need to check
        // for that best example: scrolls do not have them
        if (self.view.class) {
            touchDict[kVAKTouchView] = NSStringFromClass(self.view.class);
        }
    } @catch(NSException *e) {
        NSLog(@"\n- VAKError: Touch has no View.class: %@", e.reason);
    }
    
    return touchDict;
}

- (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
    return self;
}

@end
