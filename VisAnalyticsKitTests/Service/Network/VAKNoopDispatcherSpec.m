//
//  VAKNoopDispatcherSpec.m
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
#import "VAKNoopDispatcher.h"

SpecBegin(VAKNoopDispatcher)

describe(@"VAKNoopDispatcher", ^{
    
    __block VAKNoopDispatcher *noopDispatcher;
    
    beforeAll(^{
        noopDispatcher = [[VAKNoopDispatcher alloc]init];
    });
    
    it(@"conforms to the dispatcher protocol", ^{
       expect(noopDispatcher).conformTo(@protocol(VAKRemoteDispatchProtocol));
    });
    
    it(@"always returns the same nsstring when pull is called", ^{
        expect([noopDispatcher pull:@"foo"]).to.equal(kVAKNoopDispatcherPullResult);
        expect([noopDispatcher pull:@"baz"]).to.equal(kVAKNoopDispatcherPullResult);
        expect([noopDispatcher pull:@"bar"]).to.equal(kVAKNoopDispatcherPullResult);
    });
    
    it(@"always returns true on push", ^{
        expect([noopDispatcher push]).to.beTruthy();
    });
});

SpecEnd
