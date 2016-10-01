//
//  ProvSessionFactory.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 22.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvSessionFactory.h"
#import "NSDate+VAKISOFormat.h"

@implementation VAKProvSessionFactory

+ (VAKProv *)createWithSession:(VAKSession *)session {
    VAKProv *prov = [[VAKProv alloc] init];
    
    prov.entity = [VAKProvEntity createProvComponent:VAKProvEntity.class
        withProperties:@{
            session.entityId:@{
                kVAKProvTypePrefixed:kVAKSessionType,
                kVAKSessionStart:[NSDate vak_isoFormatDate:session.startTimestamp]
            }
        }
    ];
    
    return [super createComponents:prov];
}

@end
