//
//  NSString+ReadableLevelSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 10.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "NSString+ReadableLevel.h"


SpecBegin(NSStringReadableLevel)

describe(@"NSString+ReadableLevel", ^{

    it(@"returns a humanreadable log level", ^{
        NSString *emergency = [NSString vak_level:@(VAKLevelEmergency)];
        expect(emergency).to.equal(@"EMERGENCY");
    });
    
    it(@"by default returns debug level", ^{
        NSString *debug = [NSString vak_level:@1000];
        expect(debug).to.equal(@"INFO");
    });
    
    it(@"returns a readable name when passing a VAKLogLevel", ^{
        NSString *emergency = [NSString vak_levelFromEnum:VAKLevelEmergency];
        expect(emergency).to.equal(@"EMERGENCY");
    });
});

SpecEnd
