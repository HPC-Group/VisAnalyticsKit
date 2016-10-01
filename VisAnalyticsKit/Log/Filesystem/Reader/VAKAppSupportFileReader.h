//
//  VAKAppSupportFileReader.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKFileReaderProtocol.h"

/**
 * Implementation of the FileReaderProtocol
 * This implementation is built to retrieve files from the application supports folder
 * hence the name VAKAppSupportFileReader.
 *
 * This is currently a project specific header.
 */
@interface VAKAppSupportFileReader : NSObject<VAKFileReaderProtocol>

@end
