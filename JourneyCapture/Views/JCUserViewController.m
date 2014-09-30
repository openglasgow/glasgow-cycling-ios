//
//  JCUserViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserViewController.h"
#import "JCPathListViewController.h"
#import "JCRouteCaptureViewController.h"
#import "JCSearchViewController.h"
#import "JCStatsViewController.h"
#import "JCSigninViewController.h"
#import "JCCycleMapViewController.h"
#import "JCSettingsViewController.h"

#import "JCWeatherView.h"
#import "JCMenuTableViewCell.h"
#import "JCUserView.h"
#import "JCUserHeaderView.h"

#import "JCUserViewModel.h"
#import "JCUserJourneyListViewModel.h"
#import "JCNearbyJourneyListViewModel.h"
#import "JCWeatherViewModel.h"
#import "JCSearchJourneyListViewModel.h"
#import "JCSettingsViewModel.h"

#import "Route.h"

#import "Flurry.h"
#import <GBDeviceInfo/GBDeviceInfo.h>
#import <GSKeychain/GSKeychain.h>
#import "JCRouteManager.h"
#import "JCAPIManager.h"

#import <QuartzCore/QuartzCore.h>


@interface JCUserViewController ()

@end

@implementation JCUserViewController

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [[JCLocationManager sharedManager] setDelegate:self];
    _viewModel = [JCUserViewModel new];
    [self update];
    
    return self;
}

#pragma mark - UIViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // User details
    _userView = [[JCUserView alloc] initWithViewModel:_viewModel];
    _userView.translatesAutoresizingMaskIntoConstraints = NO;
    _userView.menuTableView.delegate = self;
    _userView.menuTableView.dataSource = self;
    _userView.menuTableView.rowHeight = 60;
    [self.view addSubview:_userView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [_userView autoRemoveConstraintsAffectingView];
    [_userView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
    // Search
    UIImage *magnifyingGlass = [UIImage imageNamed:@"magnifying-glass.png"];
    _searchButton = [[UIBarButtonItem alloc] initWithImage:magnifyingGlass style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItem = _searchButton;
    
    _searchButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showSearch];
        return [RACSignal empty];
    }];
    
    // Settings
    UIImage *settingsCog = [UIImage imageNamed:@"cog-icon.png"];
    _settingsButton = [[UIBarButtonItem alloc] initWithImage:settingsCog style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.leftBarButtonItem = _settingsButton;
    
    _settingsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showSettings];
        return [RACSignal empty];
    }];
    // Stats
    UITapGestureRecognizer *statsTapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(showStats)];
    statsTapGesture.cancelsTouchesInView = YES;
    statsTapGesture.delaysTouchesEnded = NO;
    [_userView.headerView addGestureRecognizer:statsTapGesture];
    
    // Capture
    _userView.captureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showCapture];
        return [RACSignal empty];
    }];
    
    UITapGestureRecognizer *captureTapGesture = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(showCapture)];
    captureTapGesture.cancelsTouchesInView = YES;
    captureTapGesture.delaysTouchesEnded = NO;
    [_userView.mapView addGestureRecognizer:captureTapGesture];
    
    // Nav title
    [RACObserve(self, viewModel.username) subscribeNext:^(NSString *username) {
        [self.navigationItem setTitle:username];
    }];
    
    // Set back button for pushed VCs to be titled "Me" instead of the user's name
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Me"
                                   style:UIBarButtonItemStyleBordered
                                   target:nil
                                   action:nil];
    
    [self.navigationItem setBackBarButtonItem:backButton];
    
    // Update weather
    JCWeatherView *weatherView = _userView.pulldownView;
    JCWeatherViewModel *weatherVM = weatherView.viewModel;
    [weatherVM loadWeather];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[JCLocationManager sharedManager] startUpdatingCoarse];
    
    if (_updateOnAppear) {
        [self update];
        _updateOnAppear = NO;
    }
    
    // Check capture queue
    [[JCRouteManager sharedManager] deleteIncompleteRoutes];
    [[JCRouteManager sharedManager] uploadCompletedRoutes];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_userLoadDisposable dispose];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    _userLoadDisposable = [[_viewModel loadDetails] subscribeError:^(NSError *error) {
        NSLog(@"Failed to load user");
    } completed:^{
        NSLog(@"User details loaded");
    }];
}

- (void)showStats
{
    [Flurry logEvent:@"Stats tapped"];
    JCStatsViewController *statsController = [[JCStatsViewController alloc] initWithViewModel:_viewModel];
    [self.navigationController pushViewController:statsController animated:YES];
}

- (void)showCapture
{
    [Flurry logEvent:@"Route capture tapped"];
    _updateOnAppear = YES;
    JCRouteCaptureViewController *captureController = [JCRouteCaptureViewController new];
    [self.navigationController pushViewController:captureController animated:YES];
}

- (void)showSearch
{
    [Flurry logEvent:@"Search tapped"];
    _updateOnAppear = YES;
    JCSearchJourneyListViewModel *searchVM = [JCSearchJourneyListViewModel new];
    JCSearchViewController *searchController = [[JCSearchViewController alloc]
                                                initWithViewModel:searchVM];
    [self.navigationController pushViewController:searchController animated:YES];
}

- (void)showSettings
{
    [Flurry logEvent:@"Settings tapped"];
    _updateOnAppear = YES;
    JCSettingsViewModel *settingsVM = [JCSettingsViewModel new];
    JCSettingsViewController *settingsController = [[JCSettingsViewController alloc]
                                                initWithViewModel:settingsVM];
    [self.navigationController pushViewController:settingsController animated:YES];
}

#pragma mark - JCLocationManagerDelegate

- (void)didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Got locations in user overview");
    CLLocation *location = locations[0];
    CLLocationCoordinate2D loc = location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 2500, 2500);
    [_userView.mapView setRegion:region animated:YES];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected a row");
    
    if (indexPath.row == 0) {
        // My Routes
        [Flurry logEvent:@"My routes tapped"];
        JCUserJourneyListViewModel *userRoutesVM = [JCUserJourneyListViewModel new];
        JCPathListViewController *routesVC = [[JCPathListViewController alloc] initWithViewModel:userRoutesVM];
        [self.navigationController pushViewController:routesVC animated:YES];
    } else if (indexPath.row == 1) {
        // Nearby Routes
        [Flurry logEvent:@"Nearby routes tapped"];
        JCNearbyJourneyListViewModel *nearbyRoutesVM = [JCNearbyJourneyListViewModel new];
        JCPathListViewController *routesVC = [[JCPathListViewController alloc] initWithViewModel:nearbyRoutesVM];
        [self.navigationController pushViewController:routesVC animated:YES];
    } else {
        // Cycle Map
        [Flurry logEvent:@"Cycle map tapped"];
        JCCycleMapViewController *cycleVC = [JCCycleMapViewController new];
        [self.navigationController pushViewController:cycleVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Every cell will be instantiated as it's in a tableview, no point trying to dequeue
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"JCMenuCell" owner:self options:nil];
    JCMenuTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    
    NSString *title = _viewModel.menuItems[indexPath.row];
    [cell.titleLabel setText:title];
    
    UIImage *icon = _viewModel.menuItemImages[indexPath.row];
    [cell.iconImageView setImage:icon];
    return cell;
}


@end
