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

// External
#import "Aspects.h"

// Custom
#import <VisAnalyticsKit/VisAnalyticsKit.h>

NS_ENUM(NSUInteger, MY_TEST_ENUM) {
    TEST_A = 0,
    TEST_B = 1,
    TEST_C = 2
};

@interface MyTestObj : NSObject
- (void)methodToTestWithArgs:(NSString *)test forNumber:(NSNumber *)num;
@end

@implementation MyTestObj
- (void)methodToTestWithArgs:(NSString *)test forNumber:(NSNumber *)num {}
@end


SpecBegin(VAKStateKitIntegration)

describe(@"General objc tests", ^ {
    it(@"is possible to override keys in a mutableDictionary", ^{
        NSDictionary *baseDict = @{ @"testKeyName": kVAKStateDefaultTypeValue };
        NSMutableDictionary *overridenDict = [NSMutableDictionary dictionaryWithDictionary:baseDict];
        
        overridenDict[@"testKeyName"] = @"overridenValue";
        
        expect(overridenDict[kVAKStateType]).toNot.equal(kVAKStateDefaultTypeValue);
        
        NSDictionary *dict1 = @{
                    kVAKConfigClass: @"custom",
                    kVAKConfigClassContext: @[@{
                        kVAKConfigTags: @[@"tag1", @"tag2"]
                    }]
                };
        

        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict addEntriesFromDictionary:dict1];
        [mutDict addEntriesFromDictionary:@{
            kVAKConfigClassContext: @[@{
                @"bar": @"typeTest"
            }]
        }];
        
        expect([mutDict[kVAKConfigClassContext][0] objectForKey:@"bar"]).to.beTruthy();
        
        
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
        [dict2 addEntriesFromDictionary:@{
                    kVAKConfigClass:@"defaultValue" }];
        [dict2 addEntriesFromDictionary:dict1];
        
        expect(dict2[kVAKConfigClass]).to.equal(@"custom");
    });
    
    it(@"can switch throught enum", ^{
        enum MY_TEST_ENUM test = TEST_A;
        enum MY_TEST_ENUM actual;
        
        switch(test) {
            case TEST_B:
                break;
            case TEST_C:
                break;
                
            case TEST_A:
                actual = TEST_A;
                break;
        }
        
        expect(actual).to.equal(TEST_A);
    });
    
    it(@"can switch through a enum from a dictionary", ^{
        NSDictionary *testDict = @{
            @"test": @(TEST_A)
        };
        
        enum MY_TEST_ENUM test = (enum MY_TEST_ENUM) [testDict[@"test"] integerValue];
        enum MY_TEST_ENUM actual;
        
        expect(test).to.equal(TEST_A);
        
        switch(test) {
            case TEST_B:
                break;
            case TEST_C:
                break;
                
            case TEST_A:
                actual = TEST_A;
                break;
        }
        expect(actual).to.equal(TEST_A);
    });
    
    
    it(@"is possible to get arbitrary arguments from messages with aspects", ^{
        MyTestObj *testObj = [[MyTestObj alloc] init];
    
        [testObj aspect_hookSelector:@selector(methodToTestWithArgs:forNumber:)
            withOptions:AspectPositionAfter
            usingBlock:^(id<AspectInfo> inf, NSString *str, NSNumber *num) {
                expect(str).to.equal(@"foo"); // YES
                expect(num).to.equal(@45136); // YES
                
            }
            error:nil];
        
            [testObj methodToTestWithArgs:@"foo" forNumber:@45136];
    });
    
    it(@"is possible to put an aspect call into a dictionary", ^{
        MyTestObj *testObj = [[MyTestObj alloc] init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        dict[@"test"] = [testObj aspect_hookSelector:@selector(methodToTestWithArgs:forNumber:)
            withOptions:AspectPositionAfter
            usingBlock:^(id<AspectInfo> inf, NSString *str, NSNumber *num) {
                expect(str).to.equal(@"foo"); // YES
                expect(num).to.equal(@45136); // YES
                NSLog(@"%@", inf.arguments); // foo, 45136
                
            }
            error:nil];
        
        [testObj methodToTestWithArgs:@"foo" forNumber:@45136];
    });
    
});

describe(@"VAKStateKitIntegration", ^{
    
    it(@"creates states", ^{
        NSDictionary *stateDictionary = @{
            kVAKStateData: @"#test"
        };
        id<VAKStateProtocol> state = [VAKStateFactory create:stateDictionary];
        
        expect(state).to.beInstanceOf(VAKState.class);
    });
    
    it(@"logs to the console if a nslogProvider is added as backend", ^{
        VAKLogManager *manager = [VAKLogManager sharedLogManager];
        
        __block NSUInteger counter = 0;
        
        [manager aspect_hookSelector:@selector(recordState:)
            withOptions:AspectPositionAfter
            usingBlock:^(id<AspectInfo> inf) {
                counter++;
            }
            error:nil];
    
        id backend = [VAKBackend createWithComponents:VAKBackendNSLogNoop
            name:kVAKBackendNSLogNoopName
            provider:[[VAKNSLogProvider alloc] init]
            dispatcher:[VAKNoopDispatcher sharedNoopDispatcher]
        ];
        
        [manager registerBackend:backend];
        [manager startSession];
        
        for (int i = 0; i <= 10; i++) {
           id state = [VAKState vak_createWithDictionary:@{
                   kVAKStateComment : [NSString stringWithFormat:@"%d", i],
                   kVAKStateData : [NSString stringWithFormat:@"FooBazBar State data: %d", i],
                   kVAKStateTags : @[@"tag1", @"tag2"],
                   kVAKStateLogLevel : @(VAKLevelDebug)
           }];
            
            [manager recordState:state];
        }
        [manager closeSession];
        
        expect(counter).to.beGreaterThanOrEqualTo(10);
    });

});

SpecEnd
