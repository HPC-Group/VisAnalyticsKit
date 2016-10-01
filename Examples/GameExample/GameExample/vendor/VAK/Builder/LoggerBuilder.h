//
//  LoggerBuilder.h
//

#import <Foundation/Foundation.h>
#import <VisAnalyticsKit/VisAnalyticsKit.h>


@interface LoggerBuilder : NSObject<VAKLogManagerBuilderProtocol>

+ (VAKLogManager *)createAndBuild;

@end
