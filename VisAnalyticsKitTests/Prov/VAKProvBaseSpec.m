//
//  VAKProvBaseSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 07.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvBase.h"


SpecBegin(VAKProvBase)

describe(@"VAKProvBase", ^{

    it(@"is transformable", ^{
        expect(VAKProvBase.class).conformTo(@protocol(VAKTransformableProtocol));
    });
    
    it(@"can be initialised by dictionary", ^{
        NSString *testId = @"test-id";
        NSString *testAttrib = @"testAttrib";
        
        NSDictionary<NSString *, id> *dict = @{
            testId: @{
                testAttrib: @1
            }
        };
        
        VAKProvBase *provObj = [VAKProvBase vak_createWithDictionary:dict];
        
        expect(provObj.id).to.equal(@"test-id");
        expect([provObj hasAttribute:testAttrib]).to.beTruthy();
    });
});

SpecEnd
