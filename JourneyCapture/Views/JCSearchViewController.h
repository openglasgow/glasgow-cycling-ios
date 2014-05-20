//
//  JCSearchViewController.h
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCPathListViewModel, JCSearchView;

@interface JCSearchViewController : UITableViewController  <UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) JCPathListViewModel *viewModel;
@property (strong, nonatomic) JCSearchView *searchView;
@property (strong, nonatomic) UITableView *routesTableView;
@property (strong, nonatomic) UISearchDisplayController *searchController;


@end
