//
//  VAKStatejsonProviderDispatchSpec.m
//  StatejsonProviderger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKJsonFileProvider.h"

// --

static NSString *const testId = @"test-id";
static NSString *const testType = @"#test";

// --

SpecBegin(VAKStateJsonProvider)

describe(@"VAKJsonProvider", ^{
    
    __block VAKJsonFileProvider *jsonProvider;
    
    __block id writerMock;
    __block id readerMock;
    
    beforeAll(^{
        writerMock = OCMProtocolMock(@protocol(VAKFileWriterProtocol));
        OCMStub([writerMock write:[OCMArg isKindOfClass:NSDictionary.class]]).andReturn(YES);
        
        NSDictionary *dataToSerialize = @{ kVAKStateType: testType };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataToSerialize options:NSJSONWritingPrettyPrinted error:nil];
        
        readerMock = OCMProtocolMock(@protocol(VAKFileReaderProtocol));
        OCMStub([readerMock readAsData:[OCMArg isKindOfClass:NSString.class]])
            .andReturn(jsonData);
        
        jsonProvider = [VAKJsonFileProvider createWithIOComponents:writerMock reader:readerMock folder:nil];
    });
    
    it(@"creates a valid instance when using the factory method", ^{
        VAKJsonFileProvider *tmpProvider = [VAKJsonFileProvider createWithIOComponents:writerMock reader:readerMock folder:nil];
        
        expect(tmpProvider).to.beInstanceOf(VAKJsonFileProvider.class);
        expect([tmpProvider folder]).to.beTruthy();
    });
    
    it(@"can be initialized with a specific subfolder", ^{
        NSString *folderName = @"test";
        NSString *resultFolder = [NSString stringWithFormat:@"%@/json/%@", kVAKStatesFolderName, folderName];
        
        VAKJsonFileProvider *tmpProvider = [VAKJsonFileProvider createWithIOComponents:writerMock
            reader:readerMock folder:folderName];
        expect([tmpProvider folder]).to.equal(resultFolder);
    });
        
    it(@"conforms the VAKPersistenceProviderProtocol", ^{
        expect(jsonProvider).conformTo(@protocol(VAKPersistenceProviderProtocol));
    });
    
    it(@"can save data to a json file at a specific location",^{
        expect([jsonProvider save:testId
              dataToSave:@{ kVAKStateType:testType }]).to.beTruthy();
    });
    
    it(@"can save data to a json file at a specific location with a directory prepended to the saveID",^{
        NSString *path = [@"session" stringByAppendingPathComponent:testId];
        expect([jsonProvider save:path
                       dataToSave:@{ kVAKStateType:testType }]).to.beTruthy();
    });
    
    it(@"can find json files and deserialize them as dictionary", ^{
        NSDictionary *result = [jsonProvider find:testId objectType:testType];
        expect(result[kVAKStateType]).to.equal(testType);
        result = nil;
    });
    
    it(@"handles reading errors", ^{
        // we have to override the mock to pass in erroneous data
        NSData *failingData = [NSData dataWithBytes:@"" length:2];
        readerMock = OCMProtocolMock(@protocol(VAKFileReaderProtocol));
        OCMStub([readerMock readAsData:[OCMArg isKindOfClass:NSString.class]])
            .andReturn(failingData);
        
        jsonProvider = [VAKJsonFileProvider createWithIOComponents:writerMock reader:readerMock folder:nil];
        
        NSString *missingFile = @"missingFileName";
        NSDictionary *result = [jsonProvider find:missingFile objectType:testType];
        
        expect(result[@"error"]).to.beTruthy();
    });
    
});

SpecEnd
