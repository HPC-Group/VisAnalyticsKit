//
// Created by VisAnalyticsKit on 24.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <VisAnalyticsKit/VisAnalyticsKit.h>

// \cond HIDDEN_SYMBOLS
@interface VAKBaseSelectionViewController ()

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat marginBottom;

@end
// \endcond

// ----------------------------------------
#pragma mark IMPL

@implementation VAKBaseSelectionViewController

- (instancetype)init {
    self = [super init];

    if (self) {
        // -- GENERAL
        _width = 400;
        _marginBottom = 20;
    }

    return self;
}

#pragma mark HOOKS

- (void)preLoadView {
// to be overridden by children
}

- (void)postLoadView {
// to be overridden by children
}

/**
 * using template method approach
 */
- (void)loadView {
    [self preLoadView];
    [super loadView];

    VAKReplayManager *replayManager = [VAKReplayManager sharedReplayManager];
    NSString *bgColor = replayManager.backgroundColor ? replayManager.backgroundColor : @"#5c7095";

    UIScreen *mainScreen = [UIScreen mainScreen];
    UIView *container = [[UIView alloc] initWithFrame:[mainScreen bounds]];

    // -- HEADER
    CGFloat headerY = self.navigationController.navigationBar.frame.size.height + _marginBottom;
    _header = [[VAKReplayHeader alloc] initWithFrame:CGRectMake(0, headerY, _width, 150)];

    [container setBackgroundColor:VAKUIColorFromHex(bgColor)];
    [container addSubview:_header];
    [container addSubview:[self layoutBody]];

    self.title = _viewTitle;
    self.view = container;

    [self postLoadView];
}

- (UIView *)layoutBody {
    // overridden by children
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
  // the replay controller hides the navigation bar so show it again
  self.navigationController.navigationBarHidden = NO;
}

@end
