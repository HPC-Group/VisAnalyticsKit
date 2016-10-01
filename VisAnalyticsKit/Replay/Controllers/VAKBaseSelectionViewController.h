//
// Created by VisAnalyticsKit on 24.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Custom
#import "VAKReplayHeader.h"

/**
 * This controller acts as the parent for the replay controllers.
 * It uses a template method appropach that the children can implement.
 * Those template methods are called
 * - preLoadView, this one is called before the view is loaded as the name suggests
 * - postLoadView, this one is called when a view is finished loading
 * - layoutBody, here all the layouting of a controllers view should occur
 */
@interface VAKBaseSelectionViewController : UIViewController

/**
 * sets the width of the header
 */
@property(nonatomic, readonly) CGFloat width;
/**
 * sets a general margin bottom
 */
@property(nonatomic, readonly) CGFloat marginBottom;
/**
 * sets the title that shows up in the statusbar on top
 */
@property(nonatomic, copy) NSString *viewTitle;
/**
 * the header that shows the logo and the horizontal ruler (hr)
 */
@property(strong, nonatomic) VAKReplayHeader *header;

// -------------------------
#pragma mark METHODS

/**
 * template method:
 * called before a view has been loaded
 */
- (void)preLoadView;

/**
 * template method:
 * called after a view has finished loading
 */
- (void)postLoadView;

/**
 * template method:
 * all the initializing of the child's views should be happening here
 * because it returns a UIView that is placed into a container view
 *
 * @return UIView
 */
- (UIView *)layoutBody;

@end
