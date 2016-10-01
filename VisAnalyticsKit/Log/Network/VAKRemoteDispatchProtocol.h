//
//  VAKStateDispatchProtocol.h
//  StateLogger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKStateProtocol.h"

/**
 * Responsible for pulling remotely saved data into the app and pushing
 * local data to remote locations.
 */
@protocol VAKRemoteDispatchProtocol <NSObject>

@required

/**
 *  pulls state from a remote source
 *
 *  @param NSString findId  the id of the object to pull
 *
 *  @return id  the object or nil
 */
- (id)pull:(NSString *)findId;

/**
 *  pushes the saved states to a remote location. Requires the remote side to be reachable. 
 *  If the dispatcher is of a volatile type like "console", the messages will only be
 *  printed out on the console and nothing will be pushed.
 *
 *  @return BOOL true if push was succesful
 */
- (BOOL)push;

@end
