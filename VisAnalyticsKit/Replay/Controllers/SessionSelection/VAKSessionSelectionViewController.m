//
// Created by VisAnalyticsKit on 24.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

#import <VisAnalyticsKit/VisAnalyticsKit.h>

#import "VAKSessionSelectionViewController.h"
#import "VAKSessionViewCell.h"
#import "VAKReplayViewController.h"

// \cond HIDDEN_SYMBOLS
// ---------------------------------------------------------------------------
#pragma mark LOCAL SETTINGS

static NSString *const _VAKSessionCellId = @"_VAKSessionCellId";
static CGFloat const _VAKCollectionWidth = 400;
static CGFloat const _VAKRowHeight = 90;
static CGFloat const _VAKHeaderHeight = 5;
static NSUInteger const _VAKSessionsToLoad = 10;

// ---------------------------------------------------------------------------
#pragma mark LOCAL OVERRIDES

@interface VAKSessionSelectionViewController ()

@property(nonatomic) NSUInteger offset;
@property(nonatomic) NSNumber *totalSessions;

@property(nonatomic) NSMutableArray<VAKSession *> *sessionCollection;
@property(nonatomic) UITableView *sessionTableView;
@property(nonatomic) UILabel *countSessionsLabel;
@property(nonatomic) VAKReplayViewController *replayViewController;
@property(nonatomic) UIButton *remotePullBtn;

@end
// \endcond

// ---------------------------------------------------------------------------
#pragma mark IMPL

@implementation VAKSessionSelectionViewController

- (instancetype)init {
    self = [super init];

    if (self) {
        self.viewTitle = @"Session Selection";
        _sessionCollection = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (_sessionTableView) {
    NSIndexPath *selectedIndexPath = [_sessionTableView indexPathForSelectedRow];

    if (selectedIndexPath) {
      [_sessionTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
  }
}

#pragma mark HOOKS

- (void)preLoadView {
    [self registerPullStoppedAction];
    [self loadSessions];
}

- (void)postLoadView {
    [self setSessionCount];
}

- (UIView *)layoutBody {
  UIScreen *mainScreen = [UIScreen mainScreen];
  UIView *container = [[UIView alloc] initWithFrame:mainScreen.bounds];

  // - HEADER
  CGFloat collectionY = self.header.frame.origin.y + self.header.frame.size.height + self.marginBottom;
  CGFloat collectionX = (mainScreen.bounds.size.width - _VAKCollectionWidth) / 2;
  CGFloat heightLeft = mainScreen.bounds.size.height - collectionY - 100;
  CGRect collectionRect = CGRectMake(collectionX, collectionY, _VAKCollectionWidth, heightLeft);

  // - COUNT SESSIONS
  CGRect labelRect = CGRectMake(collectionX, self.header.frame.origin.y + self.header.frame.size.height, 250, 20);
  _countSessionsLabel = [[UILabel alloc] initWithFrame:labelRect];
  _countSessionsLabel.textColor = [UIColor whiteColor];
  _countSessionsLabel.font = [UIFont systemFontOfSize:13];
  _countSessionsLabel.tag = 500;

  // - SOURCE SELECTION
  _sessionTableView = [[UITableView alloc] initWithFrame:collectionRect style:UITableViewStylePlain];
  _sessionTableView.dataSource = self;
  _sessionTableView.delegate = self;
  _sessionTableView.backgroundColor = [UIColor clearColor];
  _sessionTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

  _remotePullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [_remotePullBtn setTitle:@"Pull remote" forState:UIControlStateNormal];
  _remotePullBtn.frame = CGRectMake(collectionX + _countSessionsLabel.frame.size.width, self.header.frame.origin.y + self.header.frame.size.height, 160.0, 20);
  [_remotePullBtn addTarget:self action:@selector(pullRemoteDateAction) forControlEvents:UIControlEventTouchUpInside];

  // - ADD TO CONTAINER
  [container addSubview:_countSessionsLabel];
  [container addSubview:_sessionTableView];
  [container addSubview:_remotePullBtn];

  return container;
}

#pragma mark PULL BUTTON

- (void)pullRemoteDateAction {
  [_selectedBackend pull:kVAKSessionType];
}

- (void)registerPullStoppedAction {
  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(reloadSessions)
           name:onVAKPullStopped
         object:nil];
}

- (void)reloadSessions {
  _offset = 0;
  _totalSessions = @0;
  [_sessionCollection removeAllObjects]; // quick and dirty

  [self loadSessions];
  [_sessionTableView reloadData];
  [self setSessionCount];
}

#pragma mark SERVICE METHODS

- (void)setSessionCount {
  _totalSessions = [_selectedBackend countSessions];
  _countSessionsLabel.text = [NSString stringWithFormat:@"Sessions found: %@", _totalSessions];
}

- (void)loadSessions {
  [_sessionCollection addObjectsFromArray:[_selectedBackend findAllSessions:_VAKSessionsToLoad offset:_offset]];
  _offset += _VAKSessionsToLoad;
}

#pragma mark DELEGATE: TABLE VIEW

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  VAKSessionViewCell *cell = [_sessionTableView dequeueReusableCellWithIdentifier:_VAKSessionCellId];
  VAKSession *session = _sessionCollection[(NSUInteger) indexPath.section];

  if (cell == nil) {
    cell = [[VAKSessionViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_VAKSessionCellId];
  }

  cell.nameLabel.text = [NSString stringWithFormat:@"Session %@", [self formatDate:session.startTimestamp]];
  cell.aliasLabel.text = [NSString stringWithFormat:@"Alias: %@", session.alias];

  if (session.endTimestamp) {
    NSTimeInterval duration = [session.endTimestamp timeIntervalSinceDate:session.startTimestamp];
    cell.durationLabel.text = [NSString stringWithFormat:@"Duration: %.f", duration];
    cell.durationLabel.hidden = NO;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  VAKSession *selectedSession = _sessionCollection[(NSUInteger) indexPath.section];

  UIAlertController *alert = [UIAlertController
    alertControllerWithTitle:[NSString stringWithFormat:@">>%@<< selected", selectedSession.alias]
                     message:@"You have selected a session, the next steps might take some time, proceed anyways?"
              preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *defaultAction = [UIAlertAction
    actionWithTitle:@"Proceed"
              style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action) {
                [self loadReplayControllerWithSession:selectedSession];
            }];

  UIAlertAction *cancelAction = [UIAlertAction
    actionWithTitle:@"Cancel"
              style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action) {
                [_sessionTableView deselectRowAtIndexPath:indexPath animated:YES];
            }];

  [alert addAction:defaultAction];
  [alert addAction:cancelAction];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark REPLAY VIEW CONTROLLER

- (void)loadReplayControllerWithSession:(VAKSession *)selectedSession {
  if (!_replayViewController) {
    _replayViewController = [[VAKReplayViewController alloc] init];
  }

  VAKReplayManager *replayManager = [VAKReplayManager sharedReplayManager];
  replayManager.backend = _selectedBackend;
  replayManager.session = selectedSession;

  [self.navigationController pushViewController:_replayViewController animated:NO];
}

#pragma mark LAYOUT SPACE BETWEEN CELLS

// row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return _VAKRowHeight;
}

// to have spaces between rows, we're employing a little trick:
// we're switching rows with sections => then you have spaces between the rows :)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return _VAKHeaderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [_sessionCollection count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *v = [[UIView alloc] init];
  [v setBackgroundColor:[UIColor clearColor]];

  return v;
}

#pragma mark SCROLLING UPDATE

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat actualPosition = scrollView.contentOffset.y;
  CGFloat contentHeight = scrollView.contentSize.height - _sessionTableView.frame.size.height;

  if (actualPosition >= contentHeight) {
    [self loadSessions];

    NSNumber *currentSessionCount = @(_sessionCollection.count);
    if (currentSessionCount < _totalSessions) {
      [_sessionTableView reloadData];
    }
  }
}

#pragma mark HELPER

- (NSString *)formatDate:(NSDate *)date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

  return [dateFormatter stringFromDate:date];
}

@end
