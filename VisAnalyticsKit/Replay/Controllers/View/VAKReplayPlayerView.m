//
// Created by VisAnalyticsKit on 27.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import "VAKReplayPlayerView.h"
#import "VAKConstants.h"

static const CGFloat _VAKplayerMargin = 20;

@interface VAKReplayPlayerView()

@property(nonatomic) UIImage *playImg;
@property(nonatomic) UIImage *pauseImg;
@property(nonatomic) BOOL isPlaying;
@property(nonatomic) UIButton *playBtn;

@end

@implementation VAKReplayPlayerView

- (void)baseInit {
  NSBundle *hpcBundle = [NSBundle bundleForClass:self.class];

  // - PLAY BUTTON
  _playImg = [[UIImage alloc] initWithContentsOfFile:[hpcBundle pathForResource:@"play" ofType:@"png"]];
  _pauseImg = [[UIImage alloc] initWithContentsOfFile:[hpcBundle pathForResource:@"pause" ofType:@"png"]];
  _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  _playBtn.frame = CGRectMake(_VAKplayerMargin, 30, _playImg.size.width, _playImg.size.height);
  [self setPlayButtonIcon:_playImg];
  [_playBtn addTarget:self action:@selector(onClickPlay) forControlEvents:UIControlEventTouchUpInside];
  _isPlaying = NO;

  // - SESSION LABEL
  int sessionFontSize = 16;
  CGFloat sessionX = _playBtn.frame.origin.x + _playBtn.bounds.size.width + _VAKplayerMargin;
  CGFloat sessionY = _playBtn.frame.origin.y + (_playBtn.bounds.size.height / 2) - sessionFontSize;
  _sessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(sessionX, sessionY, 300, sessionFontSize)];
  _sessionLabel.font = [UIFont systemFontOfSize:sessionFontSize];
  _sessionLabel.textColor = [UIColor whiteColor];
  _sessionLabel.tag = 100;

  // - CLOSE BUTTON
  UIImage *closeImg = [[UIImage alloc] initWithContentsOfFile:[hpcBundle pathForResource:@"close-light" ofType:@"png"]];
  UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  CGFloat closeX = self.frame.size.width - closeImg.size.width - _VAKplayerMargin;
  closeBtn.frame = CGRectMake(closeX, 10, closeImg.size.width, closeImg.size.height);
  [closeBtn setBackgroundImage:closeImg forState:UIControlStateNormal];
  [closeBtn addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];

  // - ADD TO VIEW
  [self addSubview:_playBtn];
  [self addSubview:_sessionLabel];
  [self addSubview:closeBtn];

  [self registerEvents];
}

- (void)onClickPlay {
  _isPlaying = !_isPlaying;
  UIImage *activeStateImg = _playImg;

  if (_isPlaying) {
    activeStateImg = _pauseImg;
  }

  [self setPlayButtonIcon:activeStateImg];

  [[NSNotificationCenter defaultCenter]
    postNotificationName:onVAKClickPlay
                  object:nil];
}

- (void)onClickClose {
  [[NSNotificationCenter defaultCenter]
    postNotificationName:onVAKClickCloseReplay
                  object:nil];

  [self handleCloseOrEnd];
}

- (void)setPlayButtonIcon:(UIImage *)activeIcon {
  [_playBtn setBackgroundImage:activeIcon forState:UIControlStateNormal];
}

- (void)registerEvents {
  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(handleCloseOrEnd)
           name:onVAKSessionEnded
         object:nil];

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(handlePullStatesFinished)
           name:onVAKPullStatesFinished
         object:nil];

  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(handlePullStatesStart)
           name:onVAKPullStatesStart
         object:nil];
}

- (void)handleCloseOrEnd {
  _isPlaying = NO;
  [self setPlayButtonIcon:_playImg];
}

- (void) handlePullStatesStart {
  _playBtn.alpha = 0;
  _playBtn.enabled = NO;
}

- (void) handlePullStatesFinished {
  _playBtn.alpha = 100;
  _playBtn.enabled = YES;
}

- (void)dealloc {
  [self removeEventListeners:onVAKSessionEnded];
  [self removeEventListeners:onVAKPullStatesStart];
  [self removeEventListeners:onVAKPullStatesFinished];
}

- (void) removeEventListeners:(NSString *)event {
  [[NSNotificationCenter defaultCenter]
    removeObserver:self
              name:event
            object:nil];
}

@end
