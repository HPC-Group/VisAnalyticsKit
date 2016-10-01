//
//  VAKStateFactory.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 30.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import "VAKStateFactory.h"
#import "VAKState.h"

@implementation VAKStateFactory

+ (id<VAKStateProtocol>)create:(NSDictionary<NSString *, id> *)stateDictionary {
    return [VAKState vak_createWithDictionary:stateDictionary];
}

@end
