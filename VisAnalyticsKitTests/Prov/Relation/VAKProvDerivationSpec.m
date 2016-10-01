//
//  VAKProvDerivationSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvDerivation.h"


SpecBegin(VAKProvDerivation)

describe(@"VAKProvDerivation", ^{

    __block VAKProvDerivation *derivation;
    NSString *generatedEntityId = @"testGeneratedEntity";
    NSString *usedEntityId = @"testUsedEntity";
    NSString *activityId = @"testActivity";
    NSString *generationId = @"testGeneration";
    NSString *usageId = @"testUsage";
    
    beforeAll(^{
        derivation = [[VAKProvDerivation alloc] init];
        derivation.id = @"testId";
        derivation.generatedEntity = generatedEntityId;
        derivation.usedEntity = usedEntityId;
        derivation.activity = activityId;
        derivation.generation = generationId;
        derivation.usage = usageId;
    });
    
    it(@"can be instantiated from a dictionary", ^{
        NSDictionary<NSString *, id> *asObj = [derivation vak_objectAsDictionary];
        
        VAKProvDerivation *fromDict = [VAKProvDerivation
            createProvComponent:VAKProvDerivation.class
            withProperties:asObj
        ];
        
        expect(fromDict.generatedEntity).to.equal(generatedEntityId);
        expect(fromDict.usedEntity).to.equal(usedEntityId);
    });
    
});

SpecEnd
