//
// Created by VisAnalyticsKit on 19.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKAppSupportFilesystemHelper.h"


@implementation VAKAppSupportFilesystemHelper

+ (NSString *)getDirname:(NSString *)dirname {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
  NSString *dir = [appSupport stringByAppendingPathComponent:dirname];

  BOOL isDir;
  NSError *error;

  if (![fileManager fileExistsAtPath:dir isDirectory:&isDir]) {
    isDir = [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
  }

  return dir;
}

@end
