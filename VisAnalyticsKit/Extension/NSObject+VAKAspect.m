//
//  NSObject+VAKAspect.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 15.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "NSObject+VAKAspect.h"

@implementation NSObject (VAKAspect)

+ (id<AspectToken>)vak_intercept:(SEL)selector withOptions:(VAKInterceptionPoint)options
    usingBlock:(id)block error:(NSError **)error {
    
    return [self aspect_hookSelector:selector
                         withOptions:[self convertInterceptionPoint:options]
                          usingBlock:block
                               error:error];
}

- (id<AspectToken>)vak_intercept:(SEL)selector withOptions:(VAKInterceptionPoint)options
    usingBlock:(id)block error:(NSError **)error {

    return [self aspect_hookSelector:selector
                         withOptions:[self.class convertInterceptionPoint:options]
                          usingBlock:block
                               error:error];
}

+ (AspectOptions)convertInterceptionPoint:(VAKInterceptionPoint)interceptor {
    return (AspectOptions) [@(interceptor) integerValue];
}

@end
