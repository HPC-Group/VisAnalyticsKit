//
//  VAKProvNode.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvType.h"

@implementation VAKProvType

- (void)setType:(NSString *)type {
    [self setAttribute:kVAKProvTypePrefixed value:type];
}

- (NSString *)getType {
    if ([self hasAttribute:kVAKProvTypePrefixed]) {
        return [self getAttribute:kVAKProvTypePrefixed];
    }
    
    return nil;
}

- (void)setLabel:(NSString *)label {
    [self setAttribute:kVAKProvAttributeLabel value:label];
}

- (NSString *)getLabel {
    return [self getAttribute:kVAKProvAttributeLabel];
}

@end
