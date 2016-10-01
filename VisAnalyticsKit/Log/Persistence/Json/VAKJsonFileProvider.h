//
//  VAKJsonFileProvider.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 10.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKJsonProviderProtocol.h"
#import "VAKFileProviderProtocol.h"

/**
 * A persistence provider that saves states in json format to the Library
 * folder. It also retrieves those states from the given location
 */
@interface VAKJsonFileProvider : NSObject<VAKJsonProviderProtocol, VAKFileProviderProtocol>

@end
