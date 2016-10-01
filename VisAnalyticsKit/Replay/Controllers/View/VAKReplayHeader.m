//
//  VAKReplayHeader.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 23.04.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKReplayHeader.h"

@implementation VAKReplayHeader

- (void)baseInit {
    NSBundle *hpcBundle = [NSBundle bundleForClass:self.class];
    UIImage *headerImg = [[UIImage alloc] initWithContentsOfFile:[hpcBundle pathForResource:@"header" ofType:@"png"]];
    UIImageView *logo = [[UIImageView alloc] initWithImage:headerImg];

    CGFloat logoX = self.bounds.size.width - (headerImg.size.width / 2);
    logo.frame = CGRectMake(logoX, 0, logo.frame.size.width, logo.frame.size.height);

    UIImage *hrImage = [[UIImage alloc] initWithContentsOfFile:[hpcBundle pathForResource:@"hr" ofType:@"png"]];
    [hrImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];

    CGFloat hrX = 0;
    CGFloat hrY = logo.frame.size.height + 20;
    CGFloat hrW = [[UIScreen mainScreen] bounds].size.width;
    UIView *hrHolder = [[UIView alloc] initWithFrame:CGRectMake(hrX, hrY, hrW, 2)];
    [hrHolder setBackgroundColor:[UIColor colorWithPatternImage:hrImage]];

    [self addSubview:logo];
    [self addSubview:hrHolder];
}

@end
