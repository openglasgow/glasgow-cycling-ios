//
//  JCSearchViewController.h
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLoadingView.h"
#import "JCPathListViewModel.h"

@interface JCSearchViewController : UITableViewController

@property (strong, nonatomic) JCPathListViewModel *viewModel;
@property (strong, nonatomic) JCLoadingView *loadingView;
@property (strong, nonatomic) UITableView *routesTableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;


@end
