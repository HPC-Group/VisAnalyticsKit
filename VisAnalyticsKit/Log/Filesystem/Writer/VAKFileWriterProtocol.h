//
//  VAKFileWriterProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 * Defines a contract that all filewriters have to adhere to.
 * A very simple interface with two variations of the write method.
 */
@protocol VAKFileWriterProtocol <NSObject>

@required
/**
 * Writes string data to a file.
 *
 * @param NSString  the data to be persisted
 *
 * @param NSString  the folder name to create if it doesn't exist,
 *                  that should house the file we are writing
 *
 * @param NSString  the file name
 *
 * @param NSString  the file type extension
 *
 * @return BOOL if persisting the file was successfully
 */
- (BOOL)write:(NSString *)data folder:(NSString *)folder file:(NSString *)file extension:(NSString *)extension;

/**
 * convenience method that wraps the write method in a less error prone way
 *
 * @param NSDictionary {data: theDataToBeSaved, folder: theFolderName, file: theFilename, extension: fileExtension }
 *
 * @return BOOL if persisting the file was successfully
 */
- (BOOL)write:(NSDictionary *)data;

@end
