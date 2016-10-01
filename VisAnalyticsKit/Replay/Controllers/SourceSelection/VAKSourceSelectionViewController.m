//
//  VAKSourceSelectionViewController.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 23.04.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <VisAnalyticsKit/VisAnalyticsKit.h>

#import "VAKSourceViewCell.h"
#import "VAKSessionSelectionViewController.h"

#pragma mark PRIVATE
// \cond HIDDEN_SYMBOLS
@interface VAKSourceSelectionViewController ()

@property(strong, nonatomic) NSMutableArray<id<VAKBackendProtocol>> *backends;

@end
// \endcond

#pragma mark IMPL

@implementation VAKSourceSelectionViewController

- (instancetype)init {
  self = [super init];

  if (self) {
    self.viewTitle = @"Source Selection";
    _backends = [[NSMutableArray alloc] init];
  }

    return self;
}

#pragma mark HOOKS

- (void)preLoadView {
  [self selectDataSources];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (UIView *)layoutBody {
  UIScreen *mainScreen = [UIScreen mainScreen];

  // - SOURCE SELECTION
  CGFloat collectionY = self.header.frame.origin.y + self.header.frame.size.height + super.marginBottom;
  CGFloat collectionX = (mainScreen.bounds.size.width - self.width) / 2;
  CGFloat heightLeft = mainScreen.bounds.size.height - collectionY - 100;
  CGRect collectionRect = CGRectMake(collectionX, collectionY, self.width, heightLeft);

  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout];
  [collectionView setDataSource:self];
  [collectionView setDelegate:self];

  [collectionView registerClass:VAKSourceViewCell.class forCellWithReuseIdentifier:@"cellIdentifier"];
  [collectionView setBackgroundColor:[UIColor clearColor]];

  return collectionView;
}

#pragma mark COLLECTION VIEW

- (VAKSourceViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  VAKSourceViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

  id<VAKBackendProtocol> backend = _backends[(NSUInteger) indexPath.item];
  NSBundle *hpcBundle = [NSBundle bundleForClass:self.class];
  UIImage *backendImg;

  switch([backend getProviderStorageType]) {
    case VAKStorageDatabase:
      backendImg = [[UIImage alloc] initWithContentsOfFile:[hpcBundle pathForResource:@"couchbase-lite" ofType:@"png"]];
      break;

    case VAKStorageFile:
      backendImg = [[UIImage alloc] initWithContentsOfFile:[hpcBundle pathForResource:@"json" ofType:@"png"]];
      break;

    // we currently have no default
    default:
      break;
  }

  cell.imageView.image = backendImg;
  cell.label.text = backend.name;

  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [_backends count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(180, 180);
}

- (void)selectDataSources {
  VAKLogManager *logManager = [VAKLogManager sharedLogManager];
  NSArray *databases = [logManager getBackendByStorageType:VAKStorageDatabase];
  NSArray *files = [logManager getBackendByStorageType:VAKStorageFile];

  for (id db in databases) {
    [_backends addObject:db];
  }

  for (id file in files) {
    [_backends addObject:file];
  }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  _selectedSource = _backends[(NSUInteger) indexPath.item];

  VAKSessionSelectionViewController *sessionSelectionViewController = [[VAKSessionSelectionViewController alloc] init];
  sessionSelectionViewController.selectedBackend = _selectedSource;

  [self.navigationController pushViewController:sessionSelectionViewController animated:YES];

  return YES;
}

@end
