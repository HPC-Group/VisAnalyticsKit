//
//  VAKStateLogManagerSpec.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 23.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKLogManager.h"
#import "VAKFileProviderProtocol.h"
#import "VAKJsonFileProvider.h"

// faking it
@protocol _FileProviderProtocol <VAKPersistenceProviderProtocol, VAKFileProviderProtocol> @end

SpecBegin(VAKLogManager)

describe(@"VAKLogManager", ^{
    
    __block VAKLogManager *loggerManager;
    __block NSString *buildId;
    
    beforeEach(^{
        loggerManager = [VAKLogManager sharedLogManager];
        buildId = @"build-id-test";
    });
    
    afterEach(^{
        [loggerManager clearBackends];
        [loggerManager closeSession];
    });
    
    it(@"can only exist once", ^{
        VAKLogManager *theOnlyManager = [VAKLogManager sharedLogManager];
        
        expect(loggerManager).to.equal(theOnlyManager);
    });
    
    it(@"can start and close a session", ^{
        VAKSession *beforeStart = loggerManager.session;
        [loggerManager closeSession];
        expect(beforeStart).to.beNil();
        
        [loggerManager startSession];
        VAKSession *session = loggerManager.session;
        
        expect([loggerManager hasSession]).to.beTruthy();
        
        [loggerManager startSession];
        expect(loggerManager.session).to.equal(session);
        
        [loggerManager closeSession];
        expect([loggerManager isSessionClosed]).to.beTruthy();
    });
    
    it(@"can add state to the session and adds the sessionId to the state", ^{
        id mockState = OCMProtocolMock(@protocol(VAKStateProtocol));
        OCMStub([mockState sessionId]).andReturn(@"test");
        OCMStub([mockState entityId]).andReturn(@"test-id");
        
        [loggerManager startSession];
        [loggerManager recordState:mockState];
        
//        expect([loggerManager count]).to.equal(@1);
        // if addState is called,
        // you automatically set state.sessionId = session.entityId
        // this tries to show this behavior
        expect([mockState sessionId]).to.beTruthy();
    });
    
    it(@"answers to a call to description", ^{
        NSString *managerDescription = [loggerManager description];
        
        expect([managerDescription length]).to.beGreaterThan(0);
    });
    
    it(@"can register and deregister backends", ^{
        id backend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        NSString *backendType = @"mockBackendType";
        
        NSNumber *registeredIndex = [loggerManager registerBackend:backendType backendInstance:backend];
        expect([loggerManager hasBackends]).to.equal(YES);
        expect(registeredIndex).to.equal(0);
        expect([loggerManager countBackends]).to.equal(1);
        
        BOOL isRemoved = [loggerManager deregisterBackend:backendType];
        expect([loggerManager hasBackends]).to.equal(0);
        expect(isRemoved).to.beTruthy();
        expect([loggerManager countBackends]).to.equal(0);
    });
    
    it(@"registers a specific backend type once", ^{
        id backend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        // sets check for object equality so there has to be a second backendMock for this to work as expected
        id anotherBackendMock = OCMProtocolMock(@protocol(VAKBackendProtocol));
        NSString *backendType = @"mockBackendType";
        NSString *anotherType = @"anotherBackendType";
        
        [loggerManager registerBackend:backendType backendInstance:backend];
        [loggerManager registerBackend:anotherType backendInstance:anotherBackendMock];
        [loggerManager registerBackend:backendType backendInstance:backend];

        expect([loggerManager countBackends]).to.equal(2);
    });
    
    it(@"checks if a specific backend type has been set by type name", ^{
        id backend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        NSString *backendType = @"mockBackendType";
        NSString *missingBackendType = @"missingBackendType";
        
        [loggerManager registerBackend:backendType backendInstance:backend];
        expect([loggerManager hasBackendType:backendType]).to.beTruthy();
        expect([loggerManager hasBackendType:missingBackendType]).to.beFalsy();
    });
    
    it(@"registers backends by receiving backend objects", ^{
        id mockBackend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        OCMStub([mockBackend name]).andReturn(@"testBackend");
        
        [loggerManager registerBackend:mockBackend];
        expect([loggerManager countBackends]).to.equal(1);
    });
    
    it(@"clears all backends if needed", ^{
        id mockBackend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        OCMStub([mockBackend name]).andReturn(@"testBackend");
        
        [loggerManager registerBackend:mockBackend];
        [loggerManager clearBackends];
        
        expect([loggerManager hasBackends]).to.beFalsy();
    });
    
    it(@"sets a folder with a session timestamp when provider is file-based", ^{
        VAKJsonFileProvider *jsonProvider = [[VAKJsonFileProvider alloc] init];
        
        id mockBackend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        OCMStub([mockBackend getProviderStorageType]).andReturn(VAKStorageFile);
        OCMStub([mockBackend provider]).andReturn(jsonProvider);
        
        [loggerManager registerBackend:@"bt" backendInstance:mockBackend];
        [loggerManager startSession];
        
        VAKSession *session = [loggerManager session];
        NSDate *start = session.startTimestamp;
        
        expect(jsonProvider.storageType).to.equal(VAKStorageFile);
        expect(jsonProvider.folder).to
            .equal([NSString stringWithFormat:@"%@/json/%.0f", kVAKStatesFolderName, [start timeIntervalSince1970]]);
        
    });
    
});
SpecEnd
