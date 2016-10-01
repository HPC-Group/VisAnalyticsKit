//
// Created by VisAnalyticsKit on 24.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * A custom table view cell to reflect the session data
 */
@interface VAKSessionViewCell : UITableViewCell

/**
 * shows the name of session = Session Date when session started
 */
@property(strong, nonatomic) UILabel *nameLabel;
/**
 * the alias of a session eg. Funny Einstein 123456789
 */
@property(strong, nonatomic) UILabel *aliasLabel;
/**
 * how long was the session?
 */
@property(strong, nonatomic) UILabel *durationLabel;

@end
