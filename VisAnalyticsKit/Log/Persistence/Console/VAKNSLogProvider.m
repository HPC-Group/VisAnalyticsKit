//
//  VAKStateLogDispatcher.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import "VAKNSLogProvider.h"
#import "NSString+ReadableLevel.h"

@implementation VAKNSLogProvider

- (BOOL)save:(NSString *)saveId dataToSave:(NSDictionary<NSString *, id> *)dataToSave {
    NSLog(
        @"%@ (%@);",
        [super startFormat:@"NSLog" id:saveId data:dataToSave],
        [super dataToString:dataToSave]
    );
    
    return YES;
}

@end
