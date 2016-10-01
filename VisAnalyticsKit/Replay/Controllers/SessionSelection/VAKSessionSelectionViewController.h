//
// Created by VisAnalyticsKit on 24.04.16.
// Copyright (c) 2016 VisAnalyticsKit. MIT
//

// Custom
@class VAKSessionSelectionViewController;

/**
 * This viewc ontroller selects a specific session and passes it on to the replay manager, that will
 * take care of the states to be replayed.
 */
@interface VAKSessionSelectionViewController : VAKBaseSelectionViewController<UITableViewDataSource, UITableViewDelegate>

/**
 * the selected backend from which the state and session will be fetched
 */
@property(strong, nonatomic) id<VAKBackendProtocol> selectedBackend;

@end
