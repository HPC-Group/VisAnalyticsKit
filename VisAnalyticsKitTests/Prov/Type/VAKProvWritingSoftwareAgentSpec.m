//
//  VAKProvWritingSoftwareAgentSpec.m
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
#import "VAKProvWritingSoftwareAgent.h"

SpecBegin(VAKProvWritingSoftwareAgent)

describe(@"VAKProvWritingSoftwareAgent", ^{

    __block VAKProvWritingSoftwareAgent *agent;
    NSBundle *frameworkBundle = [NSBundle bundleForClass:VAKProvWritingSoftwareAgent.class];
    NSDictionary *infoDictionary = [frameworkBundle infoDictionary];
    
    beforeEach(^{
        agent = [[VAKProvWritingSoftwareAgent alloc] initWithDefaults];
    });
    
    it(@"can be instantiated", ^{
        expect(agent).to.beInstanceOf(VAKProvWritingSoftwareAgent.class);
    });
    
    it(@"is a type of node", ^{
        expect(agent).to.beKindOf(VAKProvType.class);
    });
    
    it(@"is of type softwareAgent", ^{
        expect([agent getType]).to.equal(kVAKProvTypeSoftwareAgent);
    });
    
    it(@"gets defaults on init", ^{
        expect(agent.id).to.equal(kVAKProvWritingAgentLabel);
        expect([agent getLabel]).to.equal(kVAKProvWritingAgentLabel);
        
        expect([agent getAttribute:kVAKProvStateKit]).to.equal(frameworkBundle.bundleIdentifier);
        expect([agent getAttribute:kVAKProvStateKitVersion]).to.equal(infoDictionary[@"CFBundleShortVersionString"]);
        
    });
    
    it(@"is serializable", ^{
        NSDictionary<NSString *, NSDictionary *> *asDict = [agent vak_objectAsDictionary];
        NSDictionary *inner = asDict[[[asDict allKeys] firstObject]];
        expect(inner[kVAKProvAttributeLabel]).to.equal(kVAKProvWritingAgentLabel);
        
        VAKProvWritingSoftwareAgent *fromDict = [VAKProvWritingSoftwareAgent
            createProvComponent:VAKProvWritingSoftwareAgent.class
            withProperties:asDict
        ];
        expect(fromDict).to.beInstanceOf(VAKProvWritingSoftwareAgent.class);
        expect([agent getAttribute:kVAKProvStateKitVersion]).to.equal(infoDictionary[@"CFBundleShortVersionString"]);
    });
});

SpecEnd
