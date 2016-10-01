//
//  VAKProvGenerationSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 07.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvGeneration.h"
#import "VAKMacros.h"

SpecBegin(VAKProvGeneration)

describe(@"VAKProvGeneration", ^{
    
    __block VAKProvGeneration *gen;
    NSString *entityId = @"testEntity";
    NSString *activityId = @"testActivity";
    
    
    beforeAll(^{
        gen = [[VAKProvGeneration alloc] initWithDefaults];
        gen.entity = entityId;
        gen.activity = activityId;
    });

    it(@"must have an entity set", ^{
        NSDictionary<NSString *, id> *genAsObj = [gen vak_objectAsDictionary];
        NSString *idString = [[genAsObj allKeys] firstObject];
        NSDictionary<NSString *, id> *inner = genAsObj[idString];
        
        expect(idString).to.beTruthy();
        expect(inner[kVAKProvEntityPrefixed]).to.equal(entityId);
        expect(gen.time).to.beKindOf(NSDate.class);
    });
    
    it(@"can be instantiated from a dictionary", ^{
        NSDictionary<NSString *, id> *genAsObj = [gen vak_objectAsDictionary];
        
        VAKProvGeneration *genFromDict = [VAKProvGeneration
            createProvComponent:VAKProvGeneration.class
            withProperties:genAsObj
        ];
        expect(genFromDict.time).to.beKindOf(NSDate.class);
    });
    
    it(@"is possible to pass in entities and activities", ^{
        VAKProvEntity *mockEntity = OCMClassMock(VAKProvEntity.class);
        OCMStub([mockEntity id]).andReturn(entityId);
        VAKProvActivity *mockActivity = OCMClassMock(VAKProvActivity.class);
        OCMStub([mockActivity id]).andReturn(activityId);
        
        VAKProvGeneration *newGen = [VAKProvGeneration
            createProvComponent:VAKProvGeneration.class
            withProperties:@{
                @"test-gen-Id" : @{
                    kVAKProvEntityPrefixed: mockEntity,
                    kVAKProvActivityPrefixed: mockActivity
                }
            }
        ];
        
        expect(newGen.entity).to.equal(entityId);
    });
    
});

SpecEnd
