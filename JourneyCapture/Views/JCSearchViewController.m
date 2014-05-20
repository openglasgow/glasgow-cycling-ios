//
//  JCSearchViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSearchViewController.h"
#import "JCPathListViewModel.h"
#import "JCSearchView.h"

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
    
    _searchView = [JCSearchView new];
    _searchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_searchView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Search"];
    [_searchView.searchBar setPlaceholder:@"Search"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [_searchView autoRemoveConstraintsAffectingView];
    [_searchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                           excludingEdge:ALEdgeTop];
    [_searchView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_searchView layoutSubviews];
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
