//
//  VAKKeychainSpec.m
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
#import "VAKKeychain.h"


SpecBegin(VAKKeychain)

describe(@"VAKKeychain", ^{

    __block VAKKeychain *keychain;
    __block NSString *service = @"testService";
    
    beforeEach(^{
        keychain = [VAKKeychain initWithService:service];
    });
    
    it(@"can be instantiated with a service", ^{
        expect(keychain.service).to.equal(service);
    });
    
    it(@"cruds items", ^{
        NSString *testKey = @"testKey";
        NSString *testValue = @"testValue";
        NSData *data = [testValue dataUsingEncoding:NSUTF8StringEncoding];
        
        BOOL inserted = [keychain create:testKey data:data];
        expect(inserted).to.beTruthy();
        
        NSString *readData = [keychain readAsString:testKey];
        expect(readData).to.equal(testValue);
        
        
        NSData *updatedData = [@"updated" dataUsingEncoding:NSUTF8StringEncoding];
        BOOL updated = [keychain update:testKey data:updatedData];
        expect(updated).to.beTruthy();
        
        BOOL deleted = [keychain remove:testKey];
        expect(deleted).to.beTruthy();
    });
    
    it(@"does not insert keys twice", ^{
        NSString *testKey = @"testKey";
        NSString *testValue = @"testValue";
        NSData *data = [testValue dataUsingEncoding:NSUTF8StringEncoding];
        
        BOOL inserted = [keychain create:testKey data:data];
        expect(inserted).to.beTruthy();
        
        BOOL insertTwo = [keychain create:testKey data:data];
        expect(insertTwo).to.beFalsy();
        
        [keychain remove:testKey];
    });
    
    it(@"returns nil if a key was not found", ^{
        NSData *readData = [keychain read:@"noneExistent"];
        expect(readData).to.beNil();
    });
    
    it(@"cannot update none existing items", ^{
        NSData *updatedData = [@"updated" dataUsingEncoding:NSUTF8StringEncoding];
        BOOL updated = [keychain update:@"noneExistent" data:updatedData];
        expect(updated).to.beFalsy();
    });
    
    it(@"cannot remove none existing items", ^{
        BOOL deleted = [keychain remove:@"noneExistent"];
        expect(deleted).to.beFalsy();
    });
});

SpecEnd
