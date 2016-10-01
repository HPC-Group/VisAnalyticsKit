//
// Created by VisAnalyticsKit on 19.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKAppSupportFileWriter.h"
#import "VAKAppSupportFilesystemHelper.h"

@implementation VAKAppSupportFileWriter

+ (instancetype)create {
  return [[VAKAppSupportFileWriter alloc] init];
}

- (BOOL)write:(NSString *)data folder:(NSString *)folder file:(NSString *)file extension:(NSString *)extension {
  BOOL isSaved = NO;
  NSError *error;
  NSString *filename = [VAKAppSupportFilesystemHelper getFilename:folder file:file extension:extension];
  isSaved = [data writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error];

  return isSaved;
}

@end
