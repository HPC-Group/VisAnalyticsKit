//
//  VAKProvDelegation.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvDelegation.h"


@implementation VAKProvDelegation

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary<NSString *, id> *props = [NSMutableDictionary
        dictionaryWithDictionary:[super vak_objectAsDictionary]
    ];
    
    [self addProp:props[super.id] forKey:kVAKProvActivityPrefixed withProp:_activity];
    [self addProp:props[super.id] forKey:kVAKProvDelegatePrefixed withProp:_delegate];
    [self addProp:props[super.id] forKey:kVAKProvResponsiblePrefixed withProp:_responsible];
    
    return props;
}

@end
