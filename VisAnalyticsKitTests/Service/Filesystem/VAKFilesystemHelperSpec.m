//
//  VAKFilesystemHelperSpec.m
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
#import "VAKLibraryFilesystemHelper.h"

// --

static NSString *const testFileName = @"testFilename";
static NSString *const testFolder = @"testFolder";
static NSString *const testExtension = @"txt";

// --

SpecBegin(VAKLibraryFilesystemHelper)

describe(@"VAKLibraryFilesystemHelper", ^{
    
    beforeAll(^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dir = [libraryDirectory stringByAppendingPathComponent:testFolder];
        
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:NULL error:NULL];
        NSString *tmpString = [[NSString alloc] init];
        NSString *testFile = [tmpString stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@.%@", testFileName, testExtension]];
        [@"test" writeToFile:testFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    });
    
    afterAll(^{
        // clean up in isle 7
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dir = [libraryDirectory stringByAppendingPathComponent:testFolder];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:dir error:NULL];
    });
    
    it(@"returns a filename and it's path", ^{
        [VAKLibraryFilesystemHelper getFilename:testFolder file:testFileName extension:testExtension];
    });
});

SpecEnd
