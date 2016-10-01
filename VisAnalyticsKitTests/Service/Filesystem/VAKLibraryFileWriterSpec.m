//
//  VAKStateLogDispatchSpec.m
//  StateLogger
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
#import "VAKLibraryFileWriter.h"
#import "VAKFileWriterProtocol.h"
#import "VAKConstants.h"

// --

static NSString *const testFolder = @"testFolder";
static NSString *const testFile = @"testFile";
static NSString *const txtExtension = @"txt";

// --

SpecBegin(VAKLibraryFileWriter)

describe(@"VAKLibraryFileWriter", ^{
    
    __block VAKLibraryFileWriter *writer;
    
    beforeAll(^{
        writer = [VAKLibraryFileWriter create];
    });
    
    afterAll(^{
        // clean up in isle 7
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dir = [libraryDirectory stringByAppendingPathComponent:testFolder];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:dir error:NULL];
    });
    
    it(@"conforms to VAKFileWriterProcol", ^{
        expect(writer).conformTo(@protocol(VAKFileWriterProtocol));
    });
    
    it(@"can write files to a specified location", ^{
        BOOL isSaved = [writer write:@"testData" folder:testFolder file:testFile extension:txtExtension];
        
        expect(isSaved).to.beTruthy();
    });
    
    it(@"can write files to a specified location via dictionary", ^{
        NSDictionary *data = @{
                               @"data": @"testData",
                               @"folder": testFolder,
                               @"file": testFile,
                               @"extension": txtExtension
                               };
        BOOL isSaved = [writer write:data];
        
        expect(isSaved).to.beTruthy();
    });
    
    it(@"throws an error if the data is missing stuff", ^{
        BOOL isSaved;
        NSDictionary *data = @{
                               @"data": @"testData",
                               @"folder": testFolder,
                               };
        
        // the extension is left out on purpose
        // if you don't catch the error the tests won't succeed!
        // In the application one should not catch NSAsserts
        // but in this testing case it's okay
        // For reference: http://stackoverflow.com/questions/6395098/handling-nsasserts-in-restkit-throws
        @try {
            isSaved = [writer write:data];
        } @catch (id ex) {
            isSaved = NO;
        }
        
        expect(isSaved).to.beFalsy();
    });
});


SpecEnd
