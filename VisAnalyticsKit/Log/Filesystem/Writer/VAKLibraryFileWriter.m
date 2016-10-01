//
//  VAKFileWriter.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKLibraryFileWriter.h"
#import "VAKLibraryFilesystemHelper.h"

@implementation VAKLibraryFileWriter

+ (instancetype)create {
    return [[VAKLibraryFileWriter alloc] init];
}

- (BOOL)write:(NSString *)data folder:(NSString *)folder file:(NSString *)file extension:(NSString *)extension {
    BOOL isSaved = NO;
    NSError *error;
    NSString *filename = [VAKLibraryFilesystemHelper getFilename:folder file:file extension:extension];
    isSaved = [data writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return isSaved;
}

- (BOOL)write:(NSDictionary<NSString *, id> *)data {
    NSAssert(data[VAKFileWriterDataKey], @"The data key is missing, make sure to acutally have data to save");
    NSAssert(data[VAKFileWriterFolderKey], @"Make sure a folder is specified");
    NSAssert(data[VAKFileWriterFileKey], @"A file name must be given");
    
    return [self write:data[VAKFileWriterDataKey]
                folder:data[VAKFileWriterFolderKey]
                  file:data[VAKFileWriterFileKey]
             extension:data[VAKFileWriterExtensionKey]];
}

@end
