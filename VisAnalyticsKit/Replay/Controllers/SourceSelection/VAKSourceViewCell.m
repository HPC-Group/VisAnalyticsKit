//
// Created by VisAnalyticsKit on 23.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKSourceViewCell.h"

@implementation VAKSourceViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        CGFloat imageDimension = 102;
        CGFloat imageX = (self.bounds.size.width - imageDimension) / 2;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 25, imageDimension, imageDimension)];
        self.imageView.backgroundColor = [UIColor clearColor];

        CGFloat labelBottom = self.bounds.size.height - 40;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelBottom, self.bounds.size.width, 16)];
        self.label.tag = 200;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        self.label.text = @"TEST";

        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];

        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
    }

    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.label = nil;
}

@end
