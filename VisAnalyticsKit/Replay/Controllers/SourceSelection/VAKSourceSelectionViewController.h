//
//  VAKSourceSelectionViewController.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 23.04.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <UIKit/UIKit.h>

// Custom
#import "VAKBaseSelectionViewController.h"

@protocol VAKBackendProtocol;

/**
 * this viewController is responsible for selecting a backend from which to load data
 */
@interface VAKSourceSelectionViewController : VAKBaseSelectionViewController<UICollectionViewDataSource, UICollectionViewDelegate>

/**
 * the selected backend
 */
@property(strong, nonatomic) id<VAKBackendProtocol> selectedSource;

@end
