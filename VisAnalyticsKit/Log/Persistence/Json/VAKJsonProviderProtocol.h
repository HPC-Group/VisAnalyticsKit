//
//  VAKJsonProviderProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 17.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKPersistenceProviderProtocol.h"
#import "VAKFileWriterProtocol.h"
#import "VAKFileReaderProtocol.h"

/**
 *  makes sure a json provider has all the necessary methods
 *  it needs
 */
@protocol VAKJsonProviderProtocol <VAKPersistenceProviderProtocol>

/**
 *  Factory method to create a jsonFileProvider with I/O components and a folder to persist or read from.
 *
 *  @param id<VAKFileWriterProtocol> writer a writer that conforms to the writerProtocol that saves data to a specific folder
 *  @param id<VAKFileReaderProtocol> reader a file reader that conforms to the readerProtocol, that reads files from a specific location
 *  @param nullable|NSString folder  a specific foldername, defaults to @"hpc.statekit.states"
 *
 *  @return VAKJsonFileProvider
 */
+ (nonnull instancetype)createWithIOComponents:(nonnull id<VAKFileWriterProtocol>)writer reader:(nonnull id<VAKFileReaderProtocol>)reader folder:(nullable NSString *)folder;

@end
