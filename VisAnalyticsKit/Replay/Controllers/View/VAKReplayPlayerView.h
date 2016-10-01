//
// Created by VisAnalyticsKit on 27.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

// Custom
#import "VAKBaseReplayView.h"

/**
 * This ist the actual replay player gui widget
 */
@interface VAKReplayPlayerView : VAKBaseReplayView

/**
 * the label that holds the session name
 */
@property(nonatomic, strong) UILabel *sessionLabel;
/**
 * the timing label is supposed to hold the current time we are at in the session
 */
@property(nonatomic, strong) UILabel *currentTimeLabel;

@end
