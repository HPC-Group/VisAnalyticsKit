//
//  VAKProvRevisionSpec.m
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
#import "VAKProvRevision.h"


SpecBegin(VAKProvRevision)

describe(@"VAKProvRevision", ^{
    __block VAKProvRevision *revision;
    NSString *generatedEntityId = @"testGeneratedEntity";
    NSString *usedEntityId = @"testUsedEntity";
    
    beforeAll(^{
        revision = [[VAKProvRevision alloc] init];
        revision.id = @"testId";
        revision.generatedEntity = generatedEntityId;
        revision.usedEntity = usedEntityId;
    });
    
    it(@"has a type of revision", ^{
        NSDictionary<NSString *, id> *asObj = [revision vak_objectAsDictionary];
        NSLog(@"-- REVISION ECHO: %@", asObj);
        
        VAKProvDerivation *fromDict = [VAKProvRevision
            createProvComponent:VAKProvRevision.class
            withProperties:asObj
        ];
        
        expect(fromDict.generatedEntity).to.equal(generatedEntityId);
        expect(fromDict.usedEntity).to.equal(usedEntityId);
        expect([fromDict getAttribute:kVAKProvTypePrefixed]).to.equal(kVAKProvTypeRevision);
    });
});

SpecEnd
