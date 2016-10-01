//
// Created by VisAnalyticsKit on 20.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

/**
 * generates a human-readable alias like docker does when not tagging
 * an image or container and to be fair also for giggles :]
 */
@interface VAKAliasGenerator : NSObject

/**
 * generates a random number and creates a readable alias
 *
 * @return NSString
 */
+ (NSString *)generate;

#pragma mark ARRAY

/**
 * helper to initialise the left side array
 */
+ (NSArray *)left;
/**
 * helper to initialise the right side array
 */
+ (NSArray *)right;

@end
