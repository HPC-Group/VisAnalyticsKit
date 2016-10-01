//
//  VAKProvActivitySpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvActivity.h"

SpecBegin(VAKProvActivity)

describe(@"VAKProvActivity", ^{
    __block VAKProvActivity *activity;
    NSString *activityLabel = @"activityLabel";
    
    beforeEach(^{
        activity = [[VAKProvActivity alloc] initWithDefaults];
        [activity setLabel:activityLabel];
    });
    
    it(@"is a provenance type", ^{
        expect(activity).to.beKindOf(VAKProvType.class);
    });
    
    it(@"has a start and end", ^{
        NSDate *now = [NSDate date];
        activity.start = now;
        activity.end = now;
        
        expect(activity.start).to.equal(now);
        expect(activity.end).to.equal(now);
    });
    
    it(@"can be serialized and deserialized", ^{
        NSDictionary<NSString *, id> *activityAsDict = [activity vak_objectAsDictionary];
        NSString *idString = [[activityAsDict allKeys] firstObject];
        NSDictionary<NSString*, id> *inner = activityAsDict[idString];
    
        expect(inner[kVAKProvStart]).to.beTruthy();
        
        VAKProvActivity *newActivity = [VAKProvActivity
            createProvComponent:VAKProvActivity.class
            withProperties:activityAsDict
        ];
        expect([newActivity getLabel]).to.equal(activityLabel);
        expect(newActivity.start).to.beKindOf(NSDate.class);
    });
    
});

SpecEnd
