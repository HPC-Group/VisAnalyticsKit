//
//  VAKFilesystemHelper.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKLibraryFilesystemHelper.h"

@implementation VAKLibraryFilesystemHelper

/**
 * Private helper.
 * Retrieves a subdirectory of NSLibraryDirectory. Why NSLibraryDirectory? Take a look at the reference:
 * https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html#//apple_ref/doc/uid/TP40010672-CH2-SW2
 * Summarizing: App data goes into the Library folder, User data goes into to the user folder :)
 *
 * If the required subfolder does not exist, it is created with all child directories. Just like calling '$ mkdir -p parentDir/childDir1/childDir2'
 *
 * @param NSString the dirname to check
 *
 * @return NSString the path to the directory eg. /the/path/to/my/awesome-new-directory
 */
+ (NSString *)getDirname:(NSString *)dirname {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dir = [libraryDirectory stringByAppendingPathComponent:dirname];

    BOOL isDir;
    NSError *error;

    if (![fileManager fileExistsAtPath:dir isDirectory:&isDir]) {
        isDir = [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
    }

    return dir;
}

@end
