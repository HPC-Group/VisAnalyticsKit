//
//  NSDate+VAKISOFormatSpec.m
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
#import "NSDate+VAKISOFormat.h"


SpecBegin(NSDateVAKISOFormat)

describe(@"NSDate+VAKISOFormat", ^{
    
    __block NSDateFormatter *formatter;
    __block NSDate *now;
    __block NSString *checkString;
    
    beforeAll(^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = kVAKISO_8601;
        
        now = [NSDate date];
        checkString = [formatter stringFromDate:now];
    });
    
    it(@"formats a date to the ISO_8601 format", ^{
        expect([NSDate vak_isoFormatDate:now]).to.equal(checkString);
    });
    
    it(@"creates a date from an ISO_8601 formatted string", ^{
        NSDate *nowFromString = [NSDate vak_dateFromIS08601:checkString];
        NSString *descriptionForNowFromString = [nowFromString description];
        NSString *descriptionForNow = [now description];
        
        BOOL isSame = [descriptionForNow isEqualToString:descriptionForNowFromString];
        
        expect(nowFromString).to.beKindOf(NSDate.class);
        expect(isSame).to.beTruthy();
    });
});

SpecEnd
