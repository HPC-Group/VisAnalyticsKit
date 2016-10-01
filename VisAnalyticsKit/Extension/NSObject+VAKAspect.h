//
//  NSObject+VAKAspect.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 15.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import "VAKConstants.h"
#import "Aspects.h"

/**
 * (shamelessly :]) facades the actual aspects implementation found in the Aspects/Aspects.h
 *
 */
@interface NSObject (VAKAspect)

/**
 * Adds a block of code before/instead/after the current `selector` for a specific class.
 *
 * @param SEL selector the selector to hook into
 * @param AspectOptions options  when is the hook called?
 * @param block Aspects replicates the type signature of the method being hooked.
 * The first parameter will be `id<AspectInfo>`, followed by all parameters of the method.
 * These parameters are optional and will be filled to match the block signature.
 * You can even use an empty block, or one that simple gets `id<AspectInfo>`.
 * 
 * @param NSError **error if your interessted in an erro you could pass in an error by ref
 *
 * @note Hooking static methods is not supported.
 * @return A token which allows to later deregister the aspect.
 */
+ (id<AspectToken>)vak_intercept:(SEL)selector
                      withOptions:(VAKInterceptionPoint)options
                       usingBlock:(id)block
                            error:(NSError **)error;

/**
 *  Adds a block of code before/instead/after the current `selector` for a specific instance.
 *  For an indepth documentation @see + (id<AspectToken>)vak_hookSelector:(SEL)selector
 *                     withOptions:(AspectOptions)options
 *                      usingBlock:(id)block
 *                           error:(NSError **)error
 *
 */
- (id<AspectToken>)vak_intercept:(SEL)selector
                      withOptions:(VAKInterceptionPoint)options
                       usingBlock:(id)block
                            error:(NSError **)error;
@end
