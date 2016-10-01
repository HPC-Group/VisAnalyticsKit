//
//  VAKCustomBackendSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 28.02.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKCustomBackend.h"


SpecBegin(VAKCustomBackend)

describe(@"VAKCustomBackend", ^{
    __block id mockProvider;
    __block id mockDispatcher;
    
    beforeEach(^{
        mockProvider = OCMProtocolMock(@protocol(VAKPersistenceProviderProtocol));
        mockDispatcher = OCMProtocolMock(@protocol(VAKRemoteDispatchProtocol));
    });
    
    it(@"is a backend and therefore confirms to the backend protocol", ^{
        expect([VAKCustomBackend conformsToProtocol:@protocol(VAKBackendProtocol)])
            .to.beTruthy();
    });
    
    it(@"creates a valid backend with the VAKBackendCustom type", ^{
        VAKCustomBackend *backend = [VAKCustomBackend createWithComponents:@"test" provider:mockProvider dispatcher:mockDispatcher];
        
        expect(backend.type).to.equal(VAKBackendCustom);
    });
    
    it(@"cannot be created with a different type other than custom", ^{
        VAKCustomBackend *backend = [VAKCustomBackend createWithComponents:VAKBackendJsonNoop name:@"test" provider:mockProvider dispatcher:mockDispatcher];
        expect(backend.type).to.equal(VAKBackendCustom);
    });
    
});

SpecEnd
