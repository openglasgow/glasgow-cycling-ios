//
//  JCSearchViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSearchViewController.h"
#import "JCSearchJourneyListViewModel.h"
#import "JCPathViewModel.h"
#import "JCSearchView.h"
#import "JCLoadingView.h"
#import "JCPathCell.h"
#import "JCRouteViewController.h"
#import "JCRouteViewModel.h"
#import "Flurry.h"
#import "JCPathListViewController.h"

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

- (void)setResultsVisible:(BOOL)visible
{
    [_searchView.resultsTableView setHidden:!visible];
    [_searchView.loadingView setHidden:visible];
    
    if (visible) {
        [_searchView.searchBar resignFirstResponder];
    }
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
    
    [self setResultsVisible:NO];
    
    [_searchView.searchBar setPlaceholder:@"Enter Destination"];
    _searchView.searchBar.delegate = self;
    _searchView.resultsTableView.delegate = self;
    _searchView.resultsTableView.dataSource = self;
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

#pragma mark - UITableView Delegate and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewModel.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _viewModel.items.count) {
        // Route
        static NSString *CellIdentifier = @"routeCell";
        
        JCPathCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"JCPathCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            cell.viewModel = self.viewModel.items[indexPath.row];
        }
        [cell setViewModel:self.viewModel.items[indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else {
        // Loading indicator cell
        UITableViewCell *cell = [[UITableViewCell alloc]
                                 initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:nil];
        
        UIActivityIndicatorView *activityIndicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = cell.center;
        [cell addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCPathViewModel *pathVM = self.viewModel.items[indexPath.row];
    if (pathVM.hasChildren) {
        // Load children items
        JCPathListViewModel *childVM = [pathVM newChild];
        JCPathListViewController *routesVC = [[JCPathListViewController alloc] initWithViewModel:childVM];
        [self.navigationController pushViewController:routesVC animated:YES];
    } else {
        // Load overview
        JCRouteViewModel *routeVM = (JCRouteViewModel *)pathVM;
        JCRouteViewController *routeController = [[JCRouteViewController alloc] initWithViewModel:routeVM];
        [self.navigationController pushViewController:routeController animated:YES];
        [Flurry logEvent:@"Route selected" withParameters:@{
                                                            @"index": @(indexPath.row),
                                                            @"total_routes": @(self.viewModel.items.count),
                                                            @"average_rating": @(pathVM.averageRating.floatValue)
                                                            }];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchView.loadingView.loading = YES;
    [self setResultsVisible:NO];
    
    NSString *query = _searchView.searchBar.text;
    [[_viewModel setDestWithAddressString:query] subscribeError:^(NSError *error) {
        NSLog(@"Error");
        _searchView.loadingView.loading = NO;
        _searchView.loadingView.infoLabel.text = @"Destination not found";
    } completed:^{
        [[_viewModel loadItems] subscribeCompleted:^{
            NSLog(@"Got %d search results", _viewModel.items.count);
            if (_viewModel.items.count == 0){
                _searchView.loadingView.loading = NO;
                _searchView.loadingView.infoLabel.text = _viewModel.noItemsError;
            } else {
                [_searchView.resultsTableView reloadData];
                [self setResultsVisible:YES];
            }
        }];
    }];
}

@end
