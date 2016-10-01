//
//  VAKTaggableProtocol.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 12.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

@protocol VAKTaggableProtocol <NSObject>

@required

/** save different types in this tags orderdset for grouping purposes*/
@property(atomic) NSMutableOrderedSet *tags;

// --

/**
 * Adds a single Tag to the set
 *
 * @param NSString the tag to add
 */
- (void)addTag:(NSString *)tag;

/**
 * Adds multiple tags at once
 *
 * @param NSArray a list of tags
 */
- (void)addTags:(NSArray<NSString *> *)tags;

/**
 * The inverse operation of addTag.
 *
 * @param NSString  the tag to remove
 *
 * @return BOOL if op was succesful
 */
- (BOOL)removeTag:(NSString *)tag;

/**
 * is the tag already in the list? if so don't add it again ;)
 * 
 * @param const NSString the tag to lookout for
 *
 * @return BOOL true if tag was found
 */
- (BOOL)hasTag:(NSString *)tag;

/**
 *  checks to see if a taggable object has tags
 *
 *  @return BOOL if it has tags
 */
- (BOOL)hasTags;

/**
 * checks whether or not a bunch of tags is in the list
 * @param NSSet tagsToLookFor  the tags to search for
 * @return BOOL
 */
- (BOOL)containsTags:(NSSet *)tagsToLookFor;

@end
