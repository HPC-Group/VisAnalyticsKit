//
//  VAKProvDerivation.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvDerivation.h"

@implementation VAKProvDerivation

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary<NSString *, id> *props = [NSMutableDictionary
        dictionaryWithDictionary:[super vak_objectAsDictionary]
    ];

    [self addProp:props[super.id] forKey:kVAKProvGeneratedEntityPrefixed withProp:_generatedEntity];
    [self addProp:props[super.id] forKey:kVAKProvUsedEntityPrefixed withProp:_usedEntity];
    
    [self addProp:props[super.id] forKey:kVAKProvUsagePrefixed withProp:_usage];
    [self addProp:props[super.id] forKey:kVAKProvActivityPrefixed withProp:_activity];
    [self addProp:props[super.id] forKey:kVAKProvGenerationPrefixed withProp:_generation];
    
    return [NSDictionary dictionaryWithDictionary:props];
}

@end
