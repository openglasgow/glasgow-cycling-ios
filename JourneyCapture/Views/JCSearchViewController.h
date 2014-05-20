//
//  JCSearchViewController.h
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCSearchJourneyListViewModel, JCSearchView;

@interface JCSearchViewController : UIViewController  <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) JCSearchJourneyListViewModel *viewModel;
@property (strong, nonatomic) JCSearchView *searchView;
@property (strong, nonatomic) UITableView *resultsTableView;
@property (strong, nonatomic) UISearchDisplayController *searchController;

- (void)setResultsVisible:(BOOL)visible;
- (id)initWithViewModel:(JCSearchJourneyListViewModel *)routesViewModel;

@end
