//
// Created by VisAnalyticsKit on 19.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 *  base helper to extend for the different types of filesystemwriters
 */
@interface VAKFilesystemHelperBase : NSObject

/**
 * retrieves a fully qualified filename. utilies the template method pattern.
 *
 * @param NSString the foldername to set
 *
 * @param NSString the filename to set
 *
 * @param NSString extension the file type extension, eg. "json"
 *
 * @return NSString the fully qualifed filename eg. /the/path/to/my/awesome/file.extension
 */
+ (NSString *)getFilename:(NSString *)folder file:(NSString *)filename extension:(NSString *)extension;

/**
 * helper to get the dirname
 */
+ (NSString *)getDirname:(NSString *)dirname;

@end
