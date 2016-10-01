//
//  VAKProvUsage.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

// Custom
#import "VAKProvUsage.h"
#import "NSDate+VAKISOFormat.h"

@implementation VAKProvUsage

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary<NSString *, id> *props = [NSMutableDictionary
        dictionaryWithDictionary:[super vak_objectAsDictionary]
    ];
    
    [self addProp:props[super.id] forKey:kVAKProvActivityPrefixed withProp:_activity];
    [self addProp:props[super.id] forKey:kVAKProvEntityPrefixed withProp:_entity];
    [self addProp:props[super.id] forKey:kVAKProvTimePrefixed withProp:[NSDate vak_isoFormatDate:_time]];

    return props;
}

@end
