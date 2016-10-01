//
//  VAKAbstractBackendSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 20.02.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKBackend.h"
#import "VAKState.h"
#import "VAKSession.h"

// --

static NSString *const testId = @"test-session-state-id-00001";
static NSString *const testType = @"testType";

// --

SpecBegin(VAKBackend)

describe(@"VAKBackend", ^{
    
    __block VAKBackend *backend;
    __block id provider;
    __block id dispatcher;
    __block NSDictionary *saveAndResultDictionary = @{ kVAKStateData:testType };
    __block NSDictionary *stateToTransformerDict = @{
        kVAKStateSessionId: @"test-session",
        kVAKStateData: @{ @"foo": @"bar" }
    };
    
    // --
    
    beforeAll(^{
        provider = OCMProtocolMock(@protocol(VAKPersistenceProviderProtocol));
        
        OCMStub([provider find:[OCMArg isKindOfClass:NSString.class]
                    objectType:[OCMArg isKindOfClass:NSString.class]])
            .andReturn([NSDictionary dictionaryWithDictionary:stateToTransformerDict]);
        
        OCMStub([provider save:[OCMArg isKindOfClass:NSString.class] dataToSave:[OCMArg isKindOfClass:NSDictionary.class]])
            .andReturn(YES);
        OCMStub([provider storageType]).andReturn(VAKStorageCustom);
        
        dispatcher = OCMProtocolMock(@protocol(VAKRemoteDispatchProtocol));
        
        OCMStub([dispatcher pull:[OCMArg isKindOfClass:NSString.class]])
            .andReturn(saveAndResultDictionary);
        
        OCMStub([dispatcher push]).andReturn(YES);
        
        backend = [VAKBackend createWithComponents:VAKBackendNSLogNoop
            name:kVAKBackendNSLogNoopName
            provider:provider
            dispatcher:dispatcher];
    });
    
    // --
    
    it(@"conforms to the VAKBackendProtocol", ^{
        expect(backend).conformTo(@protocol(VAKBackendProtocol));
    });
    
    it(@"can be intialized with the backend components", ^{
        VAKBackend *tmp = [VAKBackend createWithComponents:VAKBackendNSLogNoop
            name:kVAKBackendNSLogNoopName
            provider:provider
            dispatcher:dispatcher];
        
        expect([tmp isConfigured]).to.beTruthy();
    });
    
    it(@"is not usable when a component is missing", ^{
        VAKBackend *tmp = [[VAKBackend alloc] init];
        
        expect([tmp isConfigured]).to.beFalsy();
    });
    
    it(@"can save and find local states", ^{
        expect([backend save:testId dataToSave:stateToTransformerDict]).to.beTruthy();
        
        id state = [backend find:testId objectType:testType];
        expect([state isKindOfClass:NSDictionary.class]).to.beTruthy();
        expect([state objectForKey:kVAKStateData]).to.beTruthy();
    });
    
    it(@"saves objects that are kind of VAKAbstractModel", ^{
        // better to mock the state, but at the time it's quicker to rely on the
        // real thing
        VAKState *state = [VAKState vak_createWithDictionary:stateToTransformerDict];
        expect([backend save:state]).to.beTruthy();
        
        VAKSession *session = [VAKSession open];
        [session addState:state];
        [session close];
        
        expect([backend save:session]).to.beTruthy();
    });
    
    it(@"pushes and pulls data from a remote location", ^{
        id state = [backend pull:testId];
        expect([state isKindOfClass:NSDictionary.class]).to.beTruthy();
        expect([state objectForKey:kVAKStateData]).to.beTruthy();
        
        expect([backend push]).to.beTruthy();
    });
    
    it(@"is able to retrieve the backend", ^{
        expect([backend getBackendType]).to.equal(VAKBackendNSLogNoop);
    });
    
    it(@"retrieves the specific storage type of the provider", ^{
        expect([backend getProviderStorageType]).to.equal(VAKStorageCustom);
    });
});

SpecEnd
