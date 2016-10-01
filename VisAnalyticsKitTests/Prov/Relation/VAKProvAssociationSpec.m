//
//  VAKProvAssociationSpec.m
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
#import "VAKProvAssociation.h"


SpecBegin(VAKProvAssociation)

describe(@"VAKProvAssociation", ^{
    __block VAKProvAssociation *assoc;
    NSString *plan = @"testEntity";
    NSString *activityId = @"testActivity";
    NSString *agentId = @"testAgent";
    
    beforeAll(^{
        assoc = [[VAKProvAssociation alloc] init];
        assoc.id = @"testId";
        assoc.plan = plan;
        assoc.activity = activityId;
        assoc.agent = agentId;
    });
    
    it(@"can be instantiated from a dictionary", ^{
        NSDictionary<NSString *, id> *asDict = [assoc vak_objectAsDictionary];

        VAKProvAssociation *fromDict = [VAKProvAssociation
            createProvComponent:VAKProvAssociation.class
            withProperties:asDict
        ];
        
        expect(fromDict.plan).to.equal(plan);
        expect(fromDict.agent).to.equal(agentId);
        expect(fromDict.activity).to.equal(activityId);
    });
});

SpecEnd
