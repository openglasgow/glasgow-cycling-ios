//
//  JCPathListViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPathListViewController.h"
#import "JCPathCell.h"
#import "JCPathListViewModel.h"
#import "JCRouteListViewModel.h"
#import "JCRouteViewController.h"
#import "JCRouteViewModel.h"
#import "JCCaptureViewModel.h"
#import "JCLoadingView.h"
#import "Flurry.h"

static NSInteger const kLoadingCellTag = 1;

@interface JCPathListViewController ()

@end

@implementation JCPathListViewController

- (id)initWithViewModel:(JCPathListViewModel *)routesViewModel
{
    self = [super init];
    if (self) {
        self.viewModel = routesViewModel;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [UIView new];
    [self.view setBackgroundColor:[UIColor jc_mediumBlueColor]];
    
    // Loading indicator
    _loadingView = [JCLoadingView new];
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_loadingView];
    _loadingView.loading = YES;
    
    // Routes table
    _routesTableView = [UITableView new];
    _routesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _routesTableView.delegate = self;
    _routesTableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:self.viewModel.title];
    
    // Load routes
    [[_viewModel loadItems] subscribeError:^(NSError *error) {
        NSLog(@"Error loading");
    } completed:^{
        NSLog(@"Loaded routes");
        _loadingView.loading = NO;
        
        if (_viewModel.items.count > 0) {
            [_loadingView removeFromSuperview];
            [self.view addSubview:_routesTableView];
            [_routesTableView reloadData];
        } else {
            _loadingView.infoLabel.text = _viewModel.noItemsError;
        }
    }];
}

- (void)viewWillLayoutSubviews
{
    if ([[self.view subviews] containsObject:_loadingView]) {
        [_loadingView autoRemoveConstraintsAffectingView];
        [_loadingView autoCenterInSuperview];
        [_loadingView layoutSubviews];
    }
    
    if ([[self.view subviews] containsObject:_routesTableView]) {
        [_routesTableView autoRemoveConstraintsAffectingView];
        [_routesTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_routesTableView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    }
    
    [super viewWillLayoutSubviews];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_viewModel.lastPageReached) {
        return _viewModel.items.count;
    } else {
        // Loading indicator road
        return _viewModel.items.count + 1;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        _viewModel.currentPage++;
        [[_viewModel loadItems] subscribeError:^(NSError *error) {
            NSLog(@"Error loading more");
        } completed:^{
            NSLog(@"Loaded more");
            [_routesTableView reloadData];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        
        cell.tag = kLoadingCellTag;
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
