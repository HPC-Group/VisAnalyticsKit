//
//  VAKAbstractModel.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 24.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKAbstractModel.h"
#import "VAKConstants.h"


@implementation VAKAbstractModel

@synthesize entityId = _entityId;
@synthesize type = _type;

// --

+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
    return [[self alloc] init];
};

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    return @{
        kVAKEntityId: _entityId,
        kVAKEntityType: _type
    };
}

#pragma mark PROV

- (VAKProvDelegatingSoftwareAgent *)getClientInfoFromProv {
    if (!_useProv) {
        return nil;
    }

    return _provenance.delegatingAgent;
}

@end
