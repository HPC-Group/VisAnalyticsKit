//
//  VAKAppSupportFileReader.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKAppSupportFileReader.h"
#import "VAKConstants.h"

@implementation VAKAppSupportFileReader

- (NSString *)read:(NSString *)filename {
    @try {
      [self fileExists:filename];
      
    } @catch (NSException *e) {
      NSLog(@"--- VAKError: file %@ does not exist!", filename);
      return @"";
    }
    
    return [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
}

- (NSData *)readAsData:(NSString *)filename {
    @try {
      [self fileExists:filename];
      
    } @catch (NSException *e) {
      NSLog(@"--- VAKError: file %@ does not exist!", filename);

    }
    
    return [NSData dataWithContentsOfFile:filename];
}


- (void)fileExists:(NSString *)filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filename]) {
        NSException *myException = [NSException
                                    exceptionWithName:@"FileNotFoundException"
                                    reason:@"File not found on system"
                                    userInfo:nil];
        @throw myException;
    }
}

- (NSArray *)scanFolderForSessionFiles:(NSString *)folder {
    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dir = [NSString stringWithFormat:@"%@/%@/json", appSupport, kVAKStatesFolderName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:dir error:nil];

    NSMutableArray *sessions = [[NSMutableArray alloc] init];

    for (NSString *tmpFolder in contents) {
        BOOL isDir;
        NSString *sessionFolder = [NSString stringWithFormat:@"%@/%@", dir, tmpFolder];

        [fileManager fileExistsAtPath:sessionFolder isDirectory:&isDir];

        if (isDir) {
            NSArray *statesAndOneSession = [fileManager contentsOfDirectoryAtPath:sessionFolder error:nil];
            NSString *match = [NSString stringWithFormat:@"%@*", kVAKSessionIdPrefix];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", match];
            NSArray *tmpResults = [statesAndOneSession filteredArrayUsingPredicate:predicate];

            if ([tmpResults count] > 0) {
                [sessions addObject:[NSString stringWithFormat:@"%@/%@", sessionFolder, [tmpResults firstObject]]];
            }
        }
    }

    return sessions;
}


@end
