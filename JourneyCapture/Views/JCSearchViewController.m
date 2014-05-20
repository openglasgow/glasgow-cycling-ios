//
//  JCSearchViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSearchViewController.h"
#import "JCLoadingView.h"
#import "JCPathListViewModel.h"

@interface JCSearchViewController ()

@end

@implementation JCSearchViewController

- (id)initWithViewModel:(JCPathListViewModel *)routesViewModel
{
    self = [super init];
    if (self) {
        self.viewModel = routesViewModel;
    }
    return self;
}

# pragma mark - UIViewController

- (void)loadView
{
    _searchBar = [UISearchBar new];
    _searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:_searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor jc_mediumBlueColor]];
    
    // Loading indicator
    _loadingView = [JCLoadingView new];
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_loadingView];
    _loadingView.loading = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    if ([[self.view subviews] containsObject:_loadingView]) {
        [_loadingView autoRemoveConstraintsAffectingView];
        [_loadingView autoCenterInSuperview];
        [_loadingView layoutSubviews];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
