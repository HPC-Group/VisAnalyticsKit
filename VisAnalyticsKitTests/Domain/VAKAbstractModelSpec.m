//
//  VAKAbstractModelSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 24.02.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKAbstractModel.h"


SpecBegin(VAKAbstractModel)

describe(@"VAKAbstractModel", ^{

    it(@"conforms to TransformableProtocol", ^{
        expect([VAKAbstractModel conformsToProtocol:@protocol(VAKTransformableProtocol)])
            .to.beTruthy();
    });
    
    it(@"is an abstract class by convention and returns an empty dictionary to conform the protocol", ^{
        id model = [VAKAbstractModel vak_createWithDictionary:@{}];
        expect(model).to.beKindOf(VAKAbstractModel.class);
    });
    
});

SpecEnd
