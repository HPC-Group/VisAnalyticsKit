//
//  VAKProvRevision.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvRevision.h"

@implementation VAKProvRevision

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setAttribute:kVAKProvTypePrefixed value:kVAKProvTypeRevision];
    }
    
    return self;
}

@end
