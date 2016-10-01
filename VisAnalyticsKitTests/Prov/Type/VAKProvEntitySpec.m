//
//  VAKProvEntitySpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvEntity.h"


SpecBegin(VAKProvEntity)

describe(@"VAKProvEntity", ^{
    NSString *entityId = @"testEntityId";
    NSString *testLabel = @"testLabel";
    
    __block VAKProvEntity *entity;
    
    beforeEach(^{
        entity = [[VAKProvEntity alloc] init];
        entity.id = entityId;
        [entity setLabel:testLabel];
    });
    
    it(@"can be instantiated", ^{
        expect(entity).to.beKindOf(VAKProvType.class);
    });
    
    it(@"can serialized instantiated through abstract factory", ^{
        NSDictionary<NSString *, id> *asDict = [entity vak_objectAsDictionary];
        expect([[asDict allKeys] firstObject]).to.equal(entityId);
        
        VAKProvEntity *factoryEntity = [VAKProvEntity createProvComponent:VAKProvEntity.class withProperties:asDict];
        
        expect(factoryEntity.id).to.equal(entityId);
        expect([factoryEntity getLabel]).to.equal(testLabel);
    });    
});

SpecEnd
