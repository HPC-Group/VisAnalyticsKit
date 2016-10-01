//
//  VAKSoftwareAgent.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

// Custom
#import "VAKConstants.h"
#import "VAKProvType.h"
#import "VAKKeychain.h"

/**
  *  a delegating software agent
  */
@interface VAKProvDelegatingSoftwareAgent : VAKProvType

/**
 *  returns information about the used os, os version and the agent type
 *
 *  @return NSDictionary<NSString *, id>
 */
+ (NSDictionary<NSString *, id> *)getAgentInfo;

/**
 *  inits the agent with setting the agent info
 *
 *  @return VAKProvDelegatingSoftwareAgent
 */
- (instancetype)initWithDefaults;

/**
 *  sets the screen info including the interface orientation
 */
- (void)setScreenInfo;

- (NSDictionary *)getClientInfo;

/**
 *  retrieves the
 *
 *  @return VAKInterfaceOrientation if set else the VAKOrientationUnknown
 */
- (VAKInterfaceOrientation)getInterfaceOrientation;

/**
 *  sets the causer dictionary that is passed through from 
 *  the factories
 *
 *  @param NSDictionary<NSString *, NSString *> causerDict dictionary with two keys: className and selector
 */
- (void)setCauser:(NSDictionary<NSString *, NSString *> *)causerDict;

/**
 *  retrieves the causer dictionary
 *
 *  @return @see setCauser 
 */
- (NSDictionary<NSString *, NSString *> *)getCauser;

/**
 * Returns the caller name that's part of the causer dictionary
 *
 * @return NSString
 */
- (NSString *)getCallerName;

@end
