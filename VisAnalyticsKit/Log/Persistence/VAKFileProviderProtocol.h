//
//  VAKFilePersistenceProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 16.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 *  makes sure that all providers that save state to a file
 *  have a folder property so that state is nicely grouped 
 *  in one physical folder to be able to archive a session more easily
 */
@protocol VAKFileProviderProtocol <NSObject>

@required

/**
 *  any given folder that should be used
 */
@property(readwrite, nonatomic, nonnull, copy) NSMutableString *folder;

// --

/**
 *  adds a subfolder to the specified folder
 *
 *  @param NSString subfolder eg the session's timestamp as name 
 */
- (void)addSubfolder:(NSString  * _Nonnull)subfolder;

@end
