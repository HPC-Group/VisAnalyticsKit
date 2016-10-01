//
//  VAKLogManagerBuilderProtocolSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 16.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKNSLogProvider.h"
#import "VAKDefaultBuilder.h"

SpecBegin(VAKDefaultBuilder)

describe(@"VAKDefaultBuilder", ^{
    
    __block VAKDefaultBuilder *builder;
    __block NSMutableDictionary *customConfig;
    
    beforeEach(^{
       builder = [[VAKDefaultBuilder alloc]init];
    });
    
    afterEach(^{
        customConfig = NULL;
        [[VAKLogManager sharedLogManager] clearBackends];
    });
    
    it(@"conforms to the BuilderProtocol", ^{
        expect(builder).conformTo(@protocol(VAKLogManagerBuilderProtocol));
    });
    
    /**
    CURRENTLY NOT IN USE ANYMORE
    it(@"merges custom and default config", ^{
        [builder build:@{
            VAKConfigViews : @[@{
                VAKConfigClass : @"TestObject",
                VAKConfigClassContext : @{
                    VAKConfigSelector : @"methodToBeExecuted"
                }// end view
            }]
        }];
        
        expect([builder.config objectForKey:VAKConfigDatabaseName]).to.beTruthy();
    });*/
    
    it(@"can set a couple of preconfigured providers by type", ^{
        NSDictionary *config = @{
            kVAKConfigWhichBackends: @[
                @(VAKBackendNSLogNoop),
                @(VAKBackendJsonNoop)
            ],
            kVAKConfigViews : @[@{
                kVAKConfigClass : @"TestObject",
                kVAKConfigClassContext : @{
                    kVAKConfigSelector : @"methodToBeExecuted"
                }// end view
            }]
        };
        
        [builder build:config];
        VAKLogManager *manager = [VAKLogManager sharedLogManager];
        
        expect([manager countBackends]).to.equal(2);
        expect([manager hasBackendType:kVAKBackendJsonNoopName]).to.beTruthy();
    });
    
    it(@"can set a single backend eg json noop", ^{
        NSDictionary *config = @{
            kVAKConfigWhichBackends: @(VAKBackendJsonNoop)
        };
        
        [builder build:config];
        VAKLogManager *manager = [VAKLogManager sharedLogManager];
        expect([manager hasBackendType:kVAKBackendJsonNoopName]).to.beTruthy();
    });
    
    it(@"sets a default backend of type VAKBackendConsoleNoop if none is set", ^{
        NSDictionary *config = @{};
        
        [builder build:config];
        VAKLogManager *manager = [VAKLogManager sharedLogManager];
        expect([manager hasBackendType:kVAKBackendConsoleNoopName]).to.beTruthy();
    });
    
    it(@"sets the VAKBackendConsoleNoop as default if a missing declaration is given", ^{
        NSUInteger missingDeclaration = 100;
        NSDictionary *config = @{
            kVAKConfigWhichBackends: @(missingDeclaration)
        };
        
        [builder build:config];
        VAKLogManager *manager = [VAKLogManager sharedLogManager];
        expect([manager hasBackendType:kVAKBackendConsoleNoopName]).to.beTruthy();
    });
    
    
    it(@"has the ability to add custom backends", ^{
        id mockBackend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        OCMStub([mockBackend name]).andReturn(@"test-backend");
        
        NSDictionary *config = @{
            kVAKConfigWhichBackends: @[
                @(VAKBackendNSLogNoop),
                @(VAKBackendJsonNoop)
            ],
            kVAKConfigCustomBackends:@[
                mockBackend
            ]
        };
        
        [builder build:config];
        
        VAKLogManager *manager = [VAKLogManager sharedLogManager];
        
        expect([manager hasBackendType:kVAKBackendNSLogNoopName]).to.beTruthy();
        expect([manager hasBackendType:kVAKBackendJsonNoopName]).to.beTruthy();
        expect([manager hasBackendType:@"test-backend"]).to.beTruthy();
        expect([manager countBackends]).to.equal(3);
    
    });
    
    it(@"can also set a single custom backend", ^{
        id mockBackend = OCMProtocolMock(@protocol(VAKBackendProtocol));
        OCMStub([mockBackend name]).andReturn(@"test-backend");
        
        NSDictionary *config = @{
            kVAKConfigCustomBackends:mockBackend
        };
        
        [builder build:config];
        
        VAKLogManager *manager = [VAKLogManager sharedLogManager];
        expect([manager hasBackendType:kVAKBackendConsoleNoopName]).to.beFalsy();
        expect([manager countBackends]).to.equal(1);
    });
    
});

SpecEnd
