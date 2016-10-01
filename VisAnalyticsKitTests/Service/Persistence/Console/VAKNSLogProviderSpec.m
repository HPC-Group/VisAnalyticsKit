//
//  VAKStateLogDispatchSpec.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKNSLogProvider.h"

SpecBegin(VAKStateLogProvider)

describe(@"VAKStateLogDispatcher", ^{
    
    __block VAKNSLogProvider *log;
    
    beforeEach(^{
        log = [[VAKNSLogProvider alloc] init];
    });
    
    it(@"conforms the VAKStateDispatcherProtocol", ^{
        expect(log).conformTo(@protocol(VAKPersistenceProviderProtocol));
    });
    
    it(@"can save state to the log",^{
        expect([log save:@"test-id"
              dataToSave:@{ kVAKStateType: @"#test" }]).to.beTruthy();
    });
    
    it(@"can find an empty dicitionary", ^{
        expect([log find:@"test-id" objectType:@"#test"]).to.beTruthy();
    });
});
SpecEnd
