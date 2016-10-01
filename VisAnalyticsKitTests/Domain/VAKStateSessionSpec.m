//
//  VAKStateSessionSpec.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 22.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKSession.h"
#import "NSDate+VAKISOFormat.h"

SpecBegin(VAKStateSession)

describe(@"VAKSession", ^{
    __block VAKSession *session;
    
    beforeEach(^{
        session = [VAKSession open];
    });
    
    it(@"can be opened", ^{
        expect(session).to.beInstanceOf(VAKSession.class);
        expect(session.entityId).to.startWith(kVAKSessionIdPrefix);
    });
    
    it(@"can be initialized", ^{
        VAKSession *tmpSession = [[VAKSession alloc] init];
        expect(tmpSession).to.beInstanceOf(VAKSession.class);
    });
    
    it(@"can be opened and has a specific start date", ^{
        expect(session.startTimestamp).to.beTruthy();
    });
    
    it(@"can be closed and has a specific end date", ^{
        [session close];
        
        expect(session.endTimestamp).to.beTruthy();
    });
    
    it(@"has a list of state objects that is empty on init", ^{
        expect([session hasStates]).to.beFalsy();
        expect([session count]).to.equal(@0);
    });
    
    it(@"has can add and remove states from the collection", ^{
        id mockState = OCMProtocolMock(@protocol(VAKStateProtocol));
        
        [session addState: mockState];
        expect([session hasStates]).to.beTruthy();
        expect([session count]).to.equal(@1);
        
        [session removeState:mockState];
        expect([session hasStates]).to.beFalsy();
        expect([session count]).to.equal(@0);
    });
    
    it(@"is unlocked when opened and locked if closed", ^{
        expect(session.isLocked).to.beFalsy();
        
        [session close];
        expect(session.isLocked).to.beTruthy();
    });
    
    it(@"can not add states if locked", ^{
        id mockState = OCMProtocolMock(@protocol(VAKStateProtocol));
        
        [session close];
        [session addState:mockState];
        
        expect([session count]).to.equal(@0);
    });
    
});

describe(@"is transformable", ^{
    
    it(@"is of type VAKTransformableProtocol because it inherits from AbstractModel", ^{
        VAKSession *session = [VAKSession open];
        expect(session).to.beKindOf(VAKAbstractModel.class);
        expect(session).conformTo(@protocol(VAKTransformableProtocol));
    });
    
    it(@"can be represented as a dictionary and reinstated", ^{
        VAKSession *session = [VAKSession open];
        NSMutableOrderedSet *states = [[NSMutableOrderedSet alloc] init];

        for (int i = 0; i < 3; i++) {
            id state = OCMProtocolMock(@protocol(VAKStateProtocol));
            [states addObject:state];
            [session addState:state];
        }
        
        [session close];
        
        NSDictionary *sessionDict = [session vak_objectAsDictionary];
        NSString *sessionId = sessionDict[kVAKEntityId];
        
        expect(sessionId).to.startWith(kVAKSessionIdPrefix);
        expect(sessionDict[kVAKSessionStart]).to.beKindOf(NSString.class);
        expect(sessionDict[kVAKSessionEnd]).to.beKindOf(NSString.class);
        expect(sessionDict[kVAKSessionStates]).to.beFalsy();
        
        // --
        NSMutableDictionary *sessionInit = [NSMutableDictionary dictionaryWithDictionary:sessionDict];
        sessionInit[kVAKSessionStates] = states;
        
        VAKSession *sessionFromDict = [VAKSession vak_createWithDictionary:sessionInit];
        expect(sessionFromDict.entityId).to.equal(sessionId);
        expect(sessionFromDict.startTimestamp).to.beKindOf(NSDate.class);
        expect(session.isLocked).to.beTruthy();
    });
    
    it(@"is possibe to pass a start date as date or string", ^{
        NSDate *start = [NSDate date];
        
        VAKSession *sessionWithDate = [VAKSession vak_createWithDictionary:@{
                kVAKSessionStart : start
        }];
        
        VAKSession *sessionWithString = [VAKSession vak_createWithDictionary:@{
                kVAKSessionStart : [NSDate vak_isoFormatDate:start]
        }];
        
        expect(sessionWithDate.startTimestamp).to.beKindOf(NSDate.class);
        expect(sessionWithString.startTimestamp).to.beKindOf(NSDate.class);
        
    });
    
});

SpecEnd
