//
// Created by VisAnalyticsKit on 23.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * A custom collection view cell to reflect the backend selection
 */
@interface VAKSourceViewCell : UICollectionViewCell

/**
 * the button image
 */
@property(strong, nonatomic) UIImageView *imageView;

/**
 * the label that describes the datasource
 */
@property(strong, nonatomic) UILabel *label;

@end
