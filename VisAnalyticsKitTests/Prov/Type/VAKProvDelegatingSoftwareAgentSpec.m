//
//  VAKProvSoftwareAgentSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvDelegatingSoftwareAgent.h"
#import "VAKLogManager.h"


#ifdef TARGET_OS_IPHONE
static NSString *const osName = @"iOS";
#elif defined TARGET_IPHONE_SIMULATOR
static NSString *const osName = @"simulator";
#elif defined TARGET_OS_MAC
static NSString *const osName = @"OSX";
#endif

SpecBegin(VAKProvDelegatingSoftwareAgent)

describe(@"VAKProvDelegatingSoftwareAgent", ^{
    __block VAKProvDelegatingSoftwareAgent *agent;
    NSString *clientId = @"fooBarBarClientUniqueId";
    NSString *appName = @"testAppName";
    NSString *appVersion = @"1.2.3";
    NSString *callerName = @"Cool McCool";
    NSDictionary *causerDict = @{
      kVAKCallerName:callerName,
      kVAKMethodCalled:@"andSon:"
    };
  
    // this is actually an anti-pattern to use the real object
    // but it is faster right now
    VAKLogManager *manager = [VAKLogManager sharedLogManager];
    
    beforeEach(^{
        manager.clientInfo = @{
            kVAKConfigClientName:appName,
            kVAKConfigClientVersion:appVersion
        };
        
        agent = [[VAKProvDelegatingSoftwareAgent alloc] initWithDefaults];
        agent.id = clientId;
        [agent setAttribute:kVAKProvApplication value:appName];
        [agent setAttribute:kVAKProvApplicationVersion value:appVersion];
    });
    
    it(@"can be instantiated", ^{
        expect(agent).to.beInstanceOf(VAKProvDelegatingSoftwareAgent.class);
    });
  
    it(@"has client information from manager", ^{
      NSDictionary *clientInfo = [agent getClientInfo];
      
      expect(clientInfo[kVAKConfigClientName]).to.equal(appName);
    });
  
    it(@"sets and gets causer information", ^{
      [agent setCauser:causerDict];
      
      NSDictionary *loadedCauser = [agent getCauser];
      expect(loadedCauser[kVAKCallerName]).to.equal(callerName);
    });
    
    it(@"should be initialized with a dictionary", ^{
       expect(agent.id).to.equal(clientId);
       expect([agent getAttribute:kVAKProvApplication]).to.equal(appName);
       expect([agent getAttribute:kVAKProvApplicationVersion]).to.equal(appVersion);
       
       NSDictionary *osInfo = [agent getAttribute:kVAKProvOS];
       expect(osInfo[kVAKProvOSName]).to.equal(osName);
       expect(osInfo[kVAKProvOSVersion])
        .to.equal([[NSProcessInfo processInfo] operatingSystemVersionString]);
    });
    
    it(@"is serializable", ^{
        [agent setCauser:causerDict];
      
        NSDictionary<NSString *, id> *agentAsDict = [agent vak_objectAsDictionary];
        NSString *idString = [[agentAsDict allKeys] firstObject];
        NSDictionary<NSString *, id> *inner = agentAsDict[idString];
      
        expect(idString).to.equal(clientId);
        expect(inner[kVAKProvApplication]).to.equal(appName);
        expect(inner[kVAKProvOS]).to.beKindOf(NSDictionary.class);
        
        VAKProvDelegatingSoftwareAgent *agentFromDict = [VAKProvDelegatingSoftwareAgent
            createProvComponent:VAKProvDelegatingSoftwareAgent.class
            withProperties:agentAsDict
        ];
        NSDictionary *clientInfo = [agentFromDict getClientInfo];
        NSDictionary *loadedCauser = [agentFromDict getCauser];
        expect(loadedCauser[kVAKCallerName]).to.equal(callerName);
      
        expect(agentFromDict.id).to.equal(clientId);
        expect([agentFromDict getAttribute:kVAKProvApplication]).to.equal(appName);
        expect(clientInfo[kVAKConfigClientName]).to.equal(appName);
    });
    
    /*it(@"can get and set an ui orientation", ^{
        VAKInterfaceOrientation orientation = [agent getInterfaceOrientation];
        expect(orientation).to.equal(VAKOrientationUnknown);

      [agent setScreenInfo];
        orientation = [agent getInterfaceOrientation];
        expect(orientation).to.equal(VAKOrientationPortrait);

    });*/
});

SpecEnd
