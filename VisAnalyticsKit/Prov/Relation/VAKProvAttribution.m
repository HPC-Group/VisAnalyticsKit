//
//  VAKProvAttribution.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvAttribution.h"

@implementation VAKProvAttribution

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary<NSString *, id> *props = [NSMutableDictionary
        dictionaryWithDictionary:[super vak_objectAsDictionary]
    ];

    [self addProp:props[self.id] forKey:kVAKProvAgentPrefixed withProp:_agent];
    [self addProp:props[self.id] forKey:kVAKProvEntityPrefixed withProp:_entity];

    return props;
}


@end
