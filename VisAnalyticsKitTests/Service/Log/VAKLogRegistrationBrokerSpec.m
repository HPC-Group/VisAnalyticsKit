//
//  VAKLogRegistrationBrokerSpec.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 28.01.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>


// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "Aspects.h"

// Custom
#import "VAKLogRegistrationBroker.h"

// --

@interface TestObject : NSObject

@property NSInteger _test;
@property NSDate *_timestamp;

- (void)methodToBeExecuted;

- (void)secondMethodToExecute;
@end

@implementation TestObject

- (void)methodToBeExecuted {
    self._timestamp = [NSDate date];
    self._test++;
}

- (void)secondMethodToExecute {
}
@end
// --

typedef void (^MyTestBlock)(id<AspectInfo> aspectInfo);

SpecBegin(VAKLogRegistrationBroker)


describe(@"VAKLogRegistrationBroker", ^{

    __block VAKLogRegistrationBroker *broker;
    __block NSInteger invocationCount;
    __block NSDate *callOrderTimestamp;
    __block MyTestBlock testBlock;

    beforeEach(^{
        callOrderTimestamp = nil;
        invocationCount = 0;
        broker = [[VAKLogRegistrationBroker alloc] init];
        
        testBlock = ^(id<AspectInfo> aspectInfo) {
            NSLog(@"----IN TESTBLOCK--\n%s", __PRETTY_FUNCTION__);
            callOrderTimestamp = [NSDate date];
            invocationCount++;
        };
    });
    
    afterEach(^{
        [broker unregisterInterceptors];
        broker = nil;
    });
    
#pragma mark test cases
    
    it(@"can be initialized", ^{
        expect(broker).to.beInstanceOf(VAKLogRegistrationBroker.class);
    });
    
    it(@"configures views and events", ^{
        __block BOOL secondBlockIsRun = NO;
        
        void (^myOtherTestBlock)(id<AspectInfo> aspectInfo) = ^(id<AspectInfo> aspectInfo) {
            secondBlockIsRun = YES;
            // loggen 
        };
        
        NSDictionary *confDict = @{
            kVAKConfigViews : @[@{
                kVAKConfigClass : @"TestObject",
                kVAKConfigClassContext : @{
                    kVAKConfigIntercept : @(VAKInterceptBefore),
                    kVAKConfigSelector : @"methodToBeExecuted",
                    kVAKConfigInterceptionBlock: testBlock
                }
            }]
            ,
            kVAKConfigEvents: @[@{
                kVAKConfigClass : @"TestObject",
                kVAKConfigClassContext : @{
                    //VAKConfigIntercept : @(VAKInterceptAfter),
                    kVAKConfigSelector : @"secondMethodToExecute",
                    kVAKConfigInterceptionBlock: myOtherTestBlock
                }
            }]
        };
        
        [broker configureWithDictionary:confDict];
        TestObject *myTest = [[TestObject alloc] init];
        [myTest methodToBeExecuted];
        [myTest secondMethodToExecute];
        
        expect(invocationCount).to.equal(1);
        expect(secondBlockIsRun).to.beTruthy();
        
    });

    it(@"calls the method in a user specific order", ^{
        NSDictionary *viewsDict = @{
            kVAKConfigViews : @[
                @{
                    kVAKConfigClass : @"TestObject",
                    kVAKConfigClassContext : @{
                        kVAKConfigIntercept : @(VAKInterceptBefore),
                        kVAKConfigSelector : @"methodToBeExecuted",
                        kVAKConfigInterceptionBlock: testBlock
                }// end context
            }]// end views
        };
        [broker configureWithDictionary:viewsDict];
        TestObject *myTest = [[TestObject alloc] init];
        [myTest methodToBeExecuted];
        
        expect([myTest._timestamp laterDate:callOrderTimestamp]).to.beTruthy();
        expect(myTest._test).to.beGreaterThan(0);
    });

    it(@"by default intercepts the real implementation after being called", ^{
        NSDictionary *viewsDict = @{
            kVAKConfigViews : @[
                @{
                    kVAKConfigClass : @"TestObject",
                    kVAKConfigClassContext : @{
                        kVAKConfigSelector : @"methodToBeExecuted",
                        kVAKConfigInterceptionBlock: testBlock
                }// end views
            }]
        };

        [broker configureWithDictionary:viewsDict];
        TestObject *myTest = [[TestObject alloc] init];
        [myTest methodToBeExecuted];
        
        NSLog(@"timeStamp: %@ earlier than %@", myTest._timestamp, callOrderTimestamp);
        expect([myTest._timestamp earlierDate:callOrderTimestamp]).to.beTruthy();
        expect(myTest._test).to.beGreaterThan(0);
    });

    it(@"can override the default block that's being called by defining a custom block", ^{
        TestObject *myTest = [[TestObject alloc] init];

        NSDictionary *viewsDict = @{
            kVAKConfigViews : @[@{
                kVAKConfigClass : @"TestObject",
                kVAKConfigClassContext : @{
                    kVAKConfigSelector : @"methodToBeExecuted",
                    kVAKConfigInterceptionBlock: testBlock
                }// end views
            }]
        };

        [broker configureWithDictionary:viewsDict];

        [myTest methodToBeExecuted];

        expect(myTest._test).to.equal(1);
        expect(invocationCount).to.equal(1);
    });

    it(@"can call multiple methods on the same class from a single context", ^{
        NSDictionary *viewsDict = @{
            kVAKConfigViews : @[
            @{
                kVAKConfigClass : @"TestObject",
                kVAKConfigClassContext :@[@{
                    kVAKConfigSelector : @"methodToBeExecuted"
                }, // end context 1
                @{
                    kVAKConfigSelector : @"secondMethodToExecute",
                    kVAKConfigInterceptionBlock: testBlock
                }] // end context 2
            }]// end views
        };

        [broker configureWithDictionary:viewsDict];
        TestObject *myTest = [[TestObject alloc] init];
        [myTest methodToBeExecuted];
        [myTest secondMethodToExecute];

        expect(myTest._test).to.beGreaterThan(0);
        expect(invocationCount).to.equal(1);
    });
    
    it(@"removes interceptors", ^{
        [broker unregisterInterceptors];
        
        expect([broker.interceptors count]).to.equal(0);
    });
    
    it(@"is possible to pass classes and instances as VAKConfigClass", ^{
        TestObject *myTest = [[TestObject alloc] init];
        
        NSDictionary *viewsDict = @{
            kVAKConfigViews: @[
            @{
                kVAKConfigClass: TestObject.class,
                kVAKConfigClassContext: @[@{
                    kVAKConfigSelector: @"methodToBeExecuted"
                }],
                kVAKConfigClass: myTest,
                kVAKConfigClassContext: @[@{
                    kVAKConfigSelector: @"secondMethodToExecute",
                    kVAKConfigInterceptionBlock: testBlock
                }]
            }]// end views
        };

        [broker configureWithDictionary:viewsDict];
        [myTest methodToBeExecuted];
        [myTest secondMethodToExecute];

        expect(myTest._test).to.beGreaterThan(0);
    });
    
    it(@"catches bogus selectors so that an app won't crash", ^{
        TestObject *myTest = [[TestObject alloc] init];
        
        NSDictionary *viewsDict = @{
            kVAKConfigViews: @[
            @{
                kVAKConfigClass: TestObject.class,
                kVAKConfigClassContext: @[@{
                    kVAKConfigSelector: @"noneExistingSelector"
                }]
            }]// end views
        };

        [broker configureWithDictionary:viewsDict];
        [myTest methodToBeExecuted];

        expect(myTest._test).to.beGreaterThan(0);
    });
});

SpecEnd
