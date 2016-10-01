//
//  VAKFileReaderSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKAppSupportFileReader.h"
#import "VAKLibraryFileWriter.h"
#import "VAKLibraryFilesystemHelper.h"

// --

static NSString *const testData = @"testData";
static NSString *const testFolder = @"testFolderForRead";
static NSString *const testFile = @"testFile";
static NSString *const txtExtension = @"txt";

// --

SpecBegin(VAKLibraryFileReader)

describe(@"VAKAppSupportFileReader", ^{
    
    __block VAKAppSupportFileReader *reader;
    
    beforeAll(^{
        reader = [[VAKAppSupportFileReader alloc] init];
        
        // this seems like a test smell because we're using a hard dependency
        // to the libraryFileWriter but really I need to see if this works
        // yeah I know one is supposed to mock the filesystem - I get it :]
        
        [[VAKLibraryFileWriter create] write:@{
            VAKFileWriterDataKey: testData,
            VAKFileWriterFolderKey:testFolder,
            VAKFileWriterFileKey:testFile,
            VAKFileWriterExtensionKey:txtExtension
            }];
    });
    
    it(@"conforms to VAKFileReaderProtocol", ^{
        expect(reader).conformTo(@protocol(VAKFileReaderProtocol));
    });
    
    it(@"reads data from a specified file in the library folder",^{
        NSString *readData;
        NSString *file = [VAKLibraryFilesystemHelper
            getFilename:testFolder
            file:testFile
            extension:txtExtension
        ];
        
        readData = [reader read:file];
    
        expect(readData).to.equal(testData);
    });
    
    it(@"reads files as data",^{
        NSData *readData;
        NSString *file = [VAKLibraryFilesystemHelper getFilename:testFolder
                                                            file:testFile
                                                       extension:txtExtension];
        
        readData = [reader readAsData:file];
        NSString *result = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        
        expect(result).to.equal(testData);
    });
    
    it(@"throws an exception when call for a bogus file", ^{
        NSString *data;
        NSString *file = [VAKLibraryFilesystemHelper getFilename:testFolder
                                                            file:@"none_existent"
                                                       extension:txtExtension];
        @try {
            data = [reader read:file];
        } @catch (id ex) {
            expect(data).to.beNull();
        }
    });
});

SpecEnd
