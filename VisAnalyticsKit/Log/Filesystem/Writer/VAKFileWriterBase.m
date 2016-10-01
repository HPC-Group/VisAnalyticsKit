//
// Created by VisAnalyticsKit on 19.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKFileWriterBase.h"


@implementation VAKFileWriterBase

+ (instancetype)create {
  return [[VAKFileWriterBase alloc] init];
}

- (BOOL)write:(NSString *)data folder:(NSString *)folder file:(NSString *)file extension:(NSString *)extension {
  return false;
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
