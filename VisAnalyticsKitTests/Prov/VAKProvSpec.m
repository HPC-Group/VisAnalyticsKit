//
//  VAKProvSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProv.h"

SpecBegin(VAKProv)

// this spec uses the real VAKProv* types
describe(@"VAKProv", ^{
    __block VAKProv *provAggregate;
    
    // Types
    
    VAKProvEntity *entity = [VAKProvEntity createProvComponent:VAKProvEntity.class
        withProperties: @{ @"test-entity-id": @{} }];
        
    VAKProvActivity *activity = [[VAKProvActivity alloc] initWithDefaults];
    VAKProvDelegatingSoftwareAgent *delegatingAgent = [[VAKProvDelegatingSoftwareAgent alloc] initWithDefaults];
    VAKProvWritingSoftwareAgent *writingAgent = [[VAKProvWritingSoftwareAgent alloc] initWithDefaults];
  
    [delegatingAgent setScreenInfo];
    [delegatingAgent setCauser:@{
      kVAKCallerName:@"TestSpecCaller",
      kVAKMethodCalled:@"methodCalled"
    }];
  
    // Relations
    NSDate *time = activity.start;
    NSDictionary *entityActivityTime = @{
        kVAKProvEntity:entity,
        kVAKProvActivity:activity,
        kVAKProvTimePrefixed:time
    };
    
    beforeEach(^{
        provAggregate = [[VAKProv alloc] init];
        provAggregate.id = @"test-provenance-aggregate";
        provAggregate.entity = entity;
        provAggregate.activity = activity;
        provAggregate.delegatingAgent = delegatingAgent;
        provAggregate.writingAgent = writingAgent;
        provAggregate.wasGeneratedBy = [VAKProvGeneration
            createProvComponent:VAKProvGeneration.class
            withProperties: @{ @"gen-id": entityActivityTime }
        ];
        provAggregate.wasAttributedTo = [VAKProvAttribution
            createProvComponent:VAKProvAttribution.class
            withProperties:@{
                @"attribution-id": @{
                    kVAKProvEntity:entity,
                    kVAKProvAgent:delegatingAgent
                }
            }
        ];
        provAggregate.used = [VAKProvUsage createProvComponent:VAKProvUsage.class
            withProperties: @{ @"usage-id": entityActivityTime }];

        provAggregate.actedOnBehalfOf = [VAKProvDelegation
            createProvComponent:VAKProvDelegation.class
            withProperties:@{
                @"delegation-id": @{
                    kVAKProvDelegatePrefixed:delegatingAgent,
                    kVAKProvResponsiblePrefixed:writingAgent,
                    kVAKProvActivityPrefixed:activity
                }
            }
        ];
        
        provAggregate.wasAssociatedWith = [VAKProvAssociation
            createProvComponent:VAKProvAssociation.class
            withProperties:@{
                @"association-id": @{
                    kVAKProvActivityPrefixed:activity,
                    kVAKProvAgentPrefixed:delegatingAgent
                }
            }
        ];
    });
    
    it(@"is a kind of provBase", ^{
        expect(provAggregate).conformTo(@protocol(VAKTransformableProtocol));
    });
    
    it(@"can be serialized", ^{
        NSDictionary<NSString *, id> *asDict = [provAggregate vak_objectAsDictionary];
      
        expect(asDict).to.beTruthy();
        expect(asDict[kVAKProvWasGeneratedBy]).to.beTruthy();
        expect(asDict[kVAKProvWasDerivedFrom]).to.beFalsy();
        expect(asDict[kVAKProvAgent]).to.beAKindOf(NSDictionary.class);
    });
    
    it(@"can be instantiated from dictionary", ^{
        NSDictionary<NSString *, id> *asDict = [provAggregate vak_objectAsDictionary];
        VAKProv *fromDict = [VAKProv vak_createWithDictionary:asDict];
        NSLog(@"fromDict: %@", fromDict);
      
        expect(fromDict).to.beTruthy();
        expect(fromDict.writingAgent).to.beKindOf(VAKProvWritingSoftwareAgent.class);
        expect(fromDict.wasAssociatedWith).to.beAKindOf(VAKProvAssociation.class);
    });
    
});

SpecEnd
