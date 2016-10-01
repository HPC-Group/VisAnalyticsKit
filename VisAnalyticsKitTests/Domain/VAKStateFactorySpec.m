//
//  VAKStateFactorySpec.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 30.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKStateFactoryProtocol.h"
#import "VAKStateFactory.h"
#import "VAKStateProtocol.h"
#import "VAKState.h"

SpecBegin(VAKStateFactory)

describe(@"VAKStateFactory", ^{
   
    it(@"conforms to the VAKStateFactoryProtocol", ^{
        expect(VAKStateFactory.class).conformTo(@protocol(VAKStateFactoryProtocol));
    });
    
    it(@"creates states", ^{
        NSDictionary *stateDictionary = @{ kVAKStateType: @"#test" };
        id state = [VAKStateFactory create:stateDictionary];
        
        expect(state).to.beInstanceOf(VAKState.class);
    });
});

SpecEnd
