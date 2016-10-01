//
//  VAKProvActivity.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvActivity.h"
#import "NSDate+VAKISOFormat.h"
#import "VAKMacros.h"

@implementation VAKProvActivity

- (instancetype)initWithDefaults {
    if (self = [super init]) {
        _start = _end = [NSDate date];
        self.id = VAK_ID(
            @"%@%s%@",
            kVAKProvActivity,
            kVAKProvDelimiter,
          [self.class vak_shortId]
        );
        
        return self;
    }
    
    return nil;
}

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary<NSString *, id> *props = [NSMutableDictionary
        dictionaryWithDictionary:[super vak_objectAsDictionary]
    ];
    
    [self addProp:props[super.id] forKey:kVAKProvStart withProp:[NSDate vak_isoFormatDate:_start]];
    [self addProp:props[super.id] forKey:kVAKProvEnd withProp:[NSDate vak_isoFormatDate:_end]];
    
    return [NSDictionary dictionaryWithDictionary:props];
}

@end
