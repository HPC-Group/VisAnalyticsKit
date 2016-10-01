//
//  VAKProvStateFactory.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 22.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvStateFactory.h"
#import "NSDate+VAKISOFormat.h"

@implementation VAKProvStateFactory

+ (VAKProv *)createWithState:(VAKState *)state {
    VAKProv *prov = [[VAKProv alloc] init];
    
    prov.entity = [VAKProvEntity createProvComponent:VAKProvEntity.class
        withProperties:@{
            state.entityId:@{
                kVAKProvTypePrefixed:kVAKStateType,

                kVAKStateTimestamp:[NSDate vak_isoFormatDate:state.timestamp]
            }
        }
    ];
    
    if ([state.causer count] > 0) {
        prov.causer = state.causer;
    }
    
    return [super createComponents:prov];
}


@end
