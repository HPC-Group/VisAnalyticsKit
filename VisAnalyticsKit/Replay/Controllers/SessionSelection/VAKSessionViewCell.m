//
// Created by VisAnalyticsKit on 24.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKSessionViewCell.h"


@implementation VAKSessionViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        CGFloat labelsX = 20;
        CGFloat nameLabelY = 20;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsX, nameLabelY, self.bounds.size.width, 18)];
        self.nameLabel.tag = 200;
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        self.nameLabel.textColor = [UIColor whiteColor];

        CGFloat aliasLabelY = nameLabelY + self.nameLabel.frame.size.height + 10;
        self.aliasLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsX, aliasLabelY, self.bounds.size.width, 14)];
        self.aliasLabel.tag = 300;
        self.aliasLabel.font = [UIFont systemFontOfSize:14];
        self.aliasLabel.textColor = [UIColor whiteColor];

        CGFloat durationLabelY = aliasLabelY + self.nameLabel.frame.size.height;
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsX, durationLabelY, self.bounds.size.width, 14)];
        self.durationLabel.tag = 400;
        self.durationLabel.font = [UIFont systemFontOfSize:14];
        self.durationLabel.textColor = [UIColor whiteColor];
        self.durationLabel.text = @"Unfinished";
        self.durationLabel.hidden = YES;

        // add
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.aliasLabel];
        [self.contentView addSubview:self.durationLabel];

        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
        self.layoutMargins = UIEdgeInsetsZero;
    }

    return self;
}

@end
