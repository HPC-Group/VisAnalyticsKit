//
//  VAKProvAttributionSpec.m
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
#import "VAKProvAttribution.h"


SpecBegin(VAKProvAttribution)

describe(@"VAKProvAttribution", ^{
    __block VAKProvAttribution *attrib;
    NSString *entityId = @"testEntity";
    NSString *agentId = @"testAgent";
    
    beforeAll(^{
        attrib = [[VAKProvAttribution alloc] init];
        attrib.id = @"testId";
        attrib.agent = agentId;
        attrib.entity = entityId;
    });
    
    it(@"can be instantiated from a dictionary", ^{
        NSDictionary<NSString *, id> *asObj = [attrib vak_objectAsDictionary];
        
        VAKProvAttribution *fromDict = [VAKProvAttribution
            createProvComponent:VAKProvAttribution.class
            withProperties:asObj
        ];
        
        expect(fromDict.agent).to.equal(agentId);
        expect(fromDict.entity).to.equal(entityId);
    });
});

SpecEnd
