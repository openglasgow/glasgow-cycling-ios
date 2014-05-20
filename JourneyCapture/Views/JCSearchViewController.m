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
#import "UIImage+color.h"

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
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor jc_mediumBlueColor]];

    _searchBar = [UISearchBar new];
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.layer.borderWidth = 0;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor jc_blueColor]];
    [self.view addSubview:_searchBar];
    
    // Loading indicator
    _loadingView = [JCLoadingView new];
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_loadingView];
    _loadingView.loading = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Search"];
    [_searchBar setPlaceholder:@"Search"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [_searchBar autoRemoveConstraintsAffectingView];
    [_searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    [_loadingView autoRemoveConstraintsAffectingView];
    [_loadingView autoCenterInSuperview];
    [_loadingView layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"CellIdentifier";
    
    // dequeue a cell from self's table view
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID];
    
    cell.textLabel.text = @"pew";
    
    return cell;
}

@end
