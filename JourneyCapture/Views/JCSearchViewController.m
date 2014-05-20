//
//  JCSearchViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSearchViewController.h"
#import "JCSearchJourneyListViewModel.h"
#import "JCSearchView.h"
#import "JCLoadingView.h"

@interface JCSearchViewController ()

@end

@implementation JCSearchViewController

- (id)initWithViewModel:(JCSearchJourneyListViewModel *)routesViewModel
{
    self = [super init];
    if (self) {
        _viewModel = routesViewModel;
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
    [_searchView.searchBar setPlaceholder:@"Enter Destination"];
    _searchView.searchBar.delegate = self;
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

- (void)searchTableList {
    NSString *searchString = _searchView.searchBar.text;
    
    NSLog(@"%@", searchString);

    
    
//    for (NSString *tempStr in contentList) {
//        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//        if (result == NSOrderedSame) {
//            [filteredContentList addObject:tempStr];
//        }
    //}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchView.loadingView.loading = YES;

    NSString *query = _searchView.searchBar.text;
    [[_viewModel setDestWithAddressString:query] subscribeError:^(NSError *error) {
        NSLog(@"Error");
        _searchView.loadingView.infoLabel.text = @"Destination not found";
    } completed:^{
        [[_viewModel loadItems] subscribeNext:^(id x) {
            NSLog(@"Got %d search results", _viewModel.items.count);
        }];
    }];
}

@end
