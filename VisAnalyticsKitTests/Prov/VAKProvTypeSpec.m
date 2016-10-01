//
//  VAKProvNodeSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvType.h"

SpecBegin(VAKProvNode)

describe(@"VAKProvNode", ^{
    
    __block VAKProvType *provType;
    
    beforeEach(^{
        provType = [[VAKProvType alloc] init];
    });
    
    it(@"can be instantiated", ^{
        expect(provType).to.beInstanceOf(VAKProvType.class);
        expect(provType).to.beKindOf(VAKProvBase.class);
    });

    it(@"can have an id", ^{
        NSString *idString = [[NSProcessInfo processInfo] globallyUniqueString];
        provType.id = idString;
        expect(provType.id).to.equal(idString);
    });
    
    it(@"has an empty attributes list on instantiation", ^{
        expect([provType.attributes count]).to.equal(0);
    });
    
    it(@"has no type set by default", ^{
        expect([provType getType]).to.beNil();
    });
    
    it(@"can have a type if set", ^{
        NSString *testType = @"testType";
        provType.attributes[kVAKProvTypePrefixed] = testType;
        
        expect([provType getType]).to.equal(testType);
        
        NSString *anotherType = @"anotherType";
        [provType setType:anotherType];
        expect([provType getType]).to.equal(anotherType);
    });
    
    it(@"sets and gets attributes", ^{
        [provType setAttribute:@"test" value:@"test"];
        expect([provType getAttribute:@"test"]).to.equal(@"test");
        
        [provType setAttribute:@"test" value:@1234];
        expect([provType getAttribute:@"test"]).to.equal(@1234);
    });
    
    it(@"has a label", ^{
        [provType setLabel:@"test"];
        expect([provType getLabel]).to.equal(@"test");
    });
    
});

SpecEnd
