//
// Created by VisAnalyticsKit on 19.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKFilesystemHelperBase.h"

@implementation VAKFilesystemHelperBase

+ (NSString *)getFilename:(NSString *)folder file:(NSString *)filename extension:(NSString *)extension {
  return [[self getDirname:folder]
    stringByAppendingPathComponent:
      [NSString stringWithFormat:@"%@.%@", filename, extension]];
}


+ (NSString *)getDirname:(NSString *)dirname {

  return dirname;
}

@end
