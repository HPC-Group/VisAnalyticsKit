//
//  VAKFileReaderProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 * Defines a simple interface that all FileReaders have to conform to.
 */
@protocol VAKFileReaderProtocol <NSObject>

@required

/**
 * Reads files from disk and returns the content as string
 *
 * @param NSString filename the file to retrieve eg. "/path/to/the/file.ext"
 *
 * @return NSString the file contents
 * @throws NSException when file was not found
 */
- (NSString *)read:(NSString *)filename;

/**
 *  Reads files from disk and returns them as NSData
 *
 *  @param NSString filename the file to retrieve eg. "/path/to/the/file.ext"
 *
 *  @return NSData the file contents as data
 *  @throws NSException when file was not found
 */
- (NSData *)readAsData:(NSString *)filename;

/**
 * scans a specific directory and returns all it's contents
 * @param NSString folder   the base folder to start searching in
 * @return NSArray
 */
- (NSArray *)scanFolderForSessionFiles:(NSString *)folder;

@end
