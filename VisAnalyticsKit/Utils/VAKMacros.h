//
//  VAKMacros.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#ifndef VAKMacros_h
#define VAKMacros_h

#import "VAKLogManager.h"
#import "NSObject+VAKShortId.h"

/**
 *  create an id that's unique that takes a format and an undisclosed number 
 *  of arguments
 *
 *  @param NSString fmt the format eg. @"%@-%s"
 *  @param ... the undisclosed args that have to match the format given!
 *
 *  @return NSString an identifier string
 */
#define VAK_ID(fmt, ...) [NSString stringWithFormat:fmt,__VA_ARGS__];

/**
 * creates a NSString from a cstring and encodes it with utf8
 */
#define VAK_CSTRING_UTF8(string) [NSString stringWithCString:string.c_str() encoding:NSUTF8StringEncoding];

#pragma mark Logger specifics

/*
@file VAKLogManager.h
@defgroup _macros LogManager Macros
\addtogroup _macros
@{
*/

#if (VAK_LOG_ON == 1)
/**
 *  a convenience macro to get a logManager and record a state
 *  with a default log level info if none is set
 *
 *  @param <id>VAKStateProtocol state the state to record
 */
#define VAK_RECORD(state)                                                      \
    [[VAKLogManager sharedLogManager] recordState:state];
/**
 *  records state by passing in a dictionary
 *  itself calls the VAK_RECORD macro
 *
 *  @param NSDictionary<NSString *, id> dict that defines the state
 */
#define VAK_RECORD_DICT(dict)                                                           \
VAK_RECORD([VAKState vak_createWithDictionary:dict]);
/*do {                                                                                    \
  NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithDictionary:dict];       \
  if (dict[kVAKStateCauser]) {                                                         \
             NSLog(@"%s", __PRETTY_FUNCTION__);                                                                         \
  }\
  VAK_RECORD([VAKState vak_createWithDictionary:dict]);                       \
} while(0)                                                                    \
*/


#else
#define VAK_RECORD(state)                                                      \
  // noop!
#define VAK_RECORD_DICT(dict)                                                   \
  // noop!
#endif

/**
 *  gets the shared logManager and starts a session
 */
#define VAK_START_SESSION()                                                      \
    [[VAKLogManager sharedLogManager] startSession];

/**
 *  closes a session
 */
#define VAK_CLOSE_SESSION()                                                      \
    [[VAKLogManager sharedLogManager] closeSession];

#define VAK_REPLAY_ON()                                                          \
    [VAKLogManager sharedLogManager].isRecording = YES

#define VAK_REPLAY_OFF()                                                         \
    [VAKLogManager sharedLogManager].isRecording = NO

/**
Doxygen grouping _macros ends
@}
 */

#endif /* VAKMacros_h */
