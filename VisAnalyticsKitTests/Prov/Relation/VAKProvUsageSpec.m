//
//  VAKProvUsageSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvUsage.h"


SpecBegin(VAKProvUsage)

describe(@"VAKProvUsage", ^{

    __block VAKProvUsage *usage;
    NSString *entityId = @"testEntity";
    NSString *activityId = @"testActivity";
    
    beforeAll(^{
        usage = [[VAKProvUsage alloc] init];
        usage.id = @"testId";
        usage.entity = entityId;
        usage.activity = activityId;
        usage.time = [NSDate date];
    });

    it(@"can be instantiated from a dictionary", ^{
        NSDictionary<NSString *, id> *asObj = [usage vak_objectAsDictionary];
        
        VAKProvUsage *fromDict = [VAKProvUsage
            createProvComponent:VAKProvUsage.class
            withProperties:asObj
        ];
        expect(fromDict.time).to.beKindOf(NSDate.class);
    });
});

SpecEnd
