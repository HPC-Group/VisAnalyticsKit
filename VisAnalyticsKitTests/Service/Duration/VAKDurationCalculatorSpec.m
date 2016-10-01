//
//  VAKDurationCalculatorSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 26.04.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKDurationCalculator.h"


SpecBegin(VAKDurationCalculator)

describe(@"VAKDurationCalculator", ^{
    __block VAKDurationCalculator *calc;
  
    beforeAll(^{
      calc = [[VAKDurationCalculator alloc] init];
    });

    it(@"can calculate a single duration between two states", ^{
      VAKState *stateA = [VAKState vak_createWithDictionary:@{
        kVAKStateTimestamp:@"2016-04-26T14:35:00.0000+0200"
      }];
      
      VAKState *stateB = [VAKState vak_createWithDictionary:@{
        kVAKStateTimestamp:@"2016-04-26T14:36:00.0000+0200"
      }];
      
      NSTimeInterval interval = [calc calcDurationBetween:stateA.timestamp andEnd:stateB.timestamp];
      long seconds = lround(interval);
      int mins = (seconds % 3600) / 60;

      expect(mins).to.equal(1);
    });
  
    it(@"calculates all durations from an array of dates", ^{
      VAKState *stateA = [VAKState vak_createWithDictionary:@{
        kVAKStateTimestamp:@"2016-04-26T14:35:00.0000+0200"
      }];
      
      VAKState *stateB = [VAKState vak_createWithDictionary:@{
        kVAKStateTimestamp:@"2016-04-26T14:36:00.0000+0200"
      }];
      VAKState *stateC = [VAKState vak_createWithDictionary:@{
        kVAKStateTimestamp:@"2016-04-26T14:38:00.0000+0200"
      }];
      
      VAKState *stateD = [VAKState vak_createWithDictionary:@{
        kVAKStateTimestamp:@"2016-04-26T14:39:00.0000+0200"
      }];
      
      NSArray *timestamps = @[
        stateA.timestamp,
        stateB.timestamp,
        stateC.timestamp,
        stateD.timestamp
      ];
      
      NSArray *results = [calc batchCalcDuration:timestamps];
      
      expect(results.count).to.equal(3);
      expect(results[1]).to.equal(120);
    });
  
    it(@"calculates all durations from an array of states", ^{
      
      NSArray *states = @[
        [VAKState vak_createWithDictionary:@{
          kVAKStateTimestamp:@"2016-04-26T14:35:00.0000+0200"
        }],
        [VAKState vak_createWithDictionary:@{
          kVAKStateTimestamp:@"2016-04-26T14:36:00.0000+0200"
        }],
        [VAKState vak_createWithDictionary:@{
          kVAKStateTimestamp:@"2016-04-26T14:38:00.0000+0200"
        }],
        [VAKState vak_createWithDictionary:@{
          kVAKStateTimestamp:@"2016-04-26T14:39.00.0000+0200"
        }]
      ];
      
      NSArray *results = [calc calcDurationForStates:states];
      
      expect(results.count).to.equal(3);
      expect(results[1]).to.equal(120);
    });
});

SpecEnd
