//
//  VAKProvAssociation.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvAssociation.h"

@implementation VAKProvAssociation

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary<NSString *, id> *props = [NSMutableDictionary
        dictionaryWithDictionary:[super vak_objectAsDictionary]
    ];
    
    [self addProp:props[super.id] forKey:kVAKProvActivityPrefixed withProp:_activity];
    [self addProp:props[super.id] forKey:kVAKProvAgentPrefixed withProp:_agent];
    [self addProp:props[super.id] forKey:kVAKProvPlanPrefixed withProp:_plan];
    
    return props;
}

@end
