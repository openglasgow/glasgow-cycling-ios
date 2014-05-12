//
//  JCJourneysViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCJourneysViewController.h"
#import "JCJourneyCell.h"
#import "JCJourneyListViewModel.h"
#import "JCRouteViewController.h"
#import "JCRouteViewModel.h"
#import "JCCaptureViewModel.h"
#import "JCLoadingView.h"
#import "Flurry.h"

@interface JCJourneysViewController ()

@end

@implementation JCJourneysViewController

- (id)initWithViewModel:(JCJourneyListViewModel *)routesViewModel
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
    [[_viewModel loadJourneys] subscribeError:^(NSError *error) {
        NSLog(@"Error loading");
    } completed:^{
        NSLog(@"Loaded routes");
        _loadingView.loading = NO;
        [_loadingView removeFromSuperview];
        [self.view addSubview:_routesTableView];
        [_routesTableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.viewModel journeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"routeCell";

    JCJourneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"JCJourneyCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        cell.viewModel = self.viewModel.journeys[indexPath.row];
    }
    [cell setViewModel:self.viewModel.journeys[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCRouteViewModel *routeVM = self.viewModel.journeys[indexPath.row];
    JCRouteViewController *routeController = [[JCRouteViewController alloc] initWithViewModel:routeVM];
    [self.navigationController pushViewController:routeController animated:YES];
    [Flurry logEvent:@"Route selected" withParameters:@{
                                                        @"index": @(indexPath.row),
                                                        @"total_routes": @(self.viewModel.journeys.count),
                                                        @"average_rating": @(routeVM.averageRating.floatValue)
                                                        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
