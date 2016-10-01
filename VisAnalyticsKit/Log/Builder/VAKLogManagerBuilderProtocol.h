//
//  VAKConfigurationBuilderProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 15.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKLogManager.h"

/**
 *  A well defined configuration interface to be used by the consumer of the 
 *  framework to keep things tidied up and to enforce decoupling
 *  Facilitates the builder pattern.
 */
@protocol VAKLogManagerBuilderProtocol <NSObject>

@required

/**
 *  configures and builds a VAKLogManager
 *
 *  @return VAKLogManager a configured and usable instance of the logger manager
 */
- (VAKLogManager *)build;

@end
