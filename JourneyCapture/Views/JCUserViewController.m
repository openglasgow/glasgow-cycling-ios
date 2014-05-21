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

#import "JCWeatherView.h"
#import "JCMenuTableViewCell.h"
#import "JCUserView.h"

#import "JCUserViewModel.h"
#import "JCUserJourneyListViewModel.h"
#import "JCNearbyJourneyListViewModel.h"
#import "JCWeatherViewModel.h"
#import "JCSearchJourneyListViewModel.h"

#import "Route.h"

#import "Flurry.h"
#import <GBDeviceInfo/GBDeviceInfo.h>
#import <GSKeychain/GSKeychain.h>
#import "JCRouteManager.h"

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
    
    UIImage *magnifyingGlass = [UIImage imageNamed:@"magnifying-glass.png"];
    _searchButton = [[UIBarButtonItem alloc] initWithImage:magnifyingGlass style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItem = _searchButton;
    
    // Search
    _searchButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showSearch];
        return [RACSignal empty];
    }];
    
    // Capture
    _userView.captureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showCapture];
        return [RACSignal empty];
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(showCapture)];
    tapGesture.cancelsTouchesInView = YES;
    tapGesture.delaysTouchesEnded = NO;
    [_userView.mapView addGestureRecognizer:tapGesture];
    
    // Nav title
    [_viewModel.fullNameSignal subscribeNext:^(NSString *fullName) {
        [self.navigationItem setTitle:fullName];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    [[_viewModel loadDetails] subscribeError:^(NSError *error) {
        NSLog(@"Failed to load user");
    } completed:^{
        NSLog(@"User details loaded");
    }];
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
        [Flurry logEvent:@"My routes tapped"];
        JCNearbyJourneyListViewModel *nearbyRoutesVM = [JCNearbyJourneyListViewModel new];
        JCPathListViewController *routesVC = [[JCPathListViewController alloc] initWithViewModel:nearbyRoutesVM];
        [self.navigationController pushViewController:routesVC animated:YES];
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
