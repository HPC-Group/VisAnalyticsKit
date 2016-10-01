//
//  VAKConsoleProviderSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 15.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKConsoleProvider.h"
#import "VAKConstants.h"

SpecBegin(VAKConsoleProvider)

describe(@"VAKConsoleProvider", ^{
    
    __block VAKConsoleProvider *log;
    
    beforeEach(^{
        log = [[VAKConsoleProvider alloc] init];
    });
    
    it(@"conforms the VAKStateDispatcherProtocol", ^{
        expect([VAKConsoleProvider conformsToProtocol:
                @protocol(VAKPersistenceProviderProtocol)]).to.beTruthy();
    });
    
    it(@"can save state to the log",^{
        expect([log save:@"test-id"
              dataToSave:@{ kVAKStateData: @"#test" }]).to.beTruthy();
    });
    
    it(@"can find an empty dicitionary", ^{
        expect([log find:@"test-id" objectType:@"#test"]).to.beTruthy();
    });
});


SpecEnd
