//
// Created by VisAnalyticsKit on 19.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

#import "VAKFileWriterProtocol.h"
#import "VAKFileWriterConstants.h"

/**
 * base file writer that holds the basic write method. uses template method.
 * in other circumstances this class would be abstract
 */
@interface VAKFileWriterBase : NSObject<VAKFileWriterProtocol>

/**
 * factory method
 */
+ (instancetype)create;

@end
