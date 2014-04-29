//
//  JCUserViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserViewController.h"
#import "JCUserViewModel.h"

#import "JCRoutesViewController.h"
#import "JCRoutesListViewModel.h"
#import "JCRouteCaptureViewController.h"
#import "JCNotificationManager.h"
#import "MBProgressHUD.h"

#import "JCUserView.h"
#import <QuartzCore/QuartzCore.h>
#import "JCWelcomeViewController.h"

#import "Flurry.h"
#import <GBDeviceInfo/GBDeviceInfo.h>
#import <GSKeychain/GSKeychain.h>

@interface JCUserViewController ()

@end

@implementation JCUserViewController

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [[JCLocationManager manager] setDelegate:self];
    _viewModel = [[JCUserViewModel alloc] init];
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

//    // Buttons
//    UIColor *buttonColor = [UIColor colorWithRed:0 green:224.0/255.0 blue:184.0/255.0 alpha:1.0];
//    
//    // My routes button
//    _myRoutesButton = [[UIButton alloc] init];
//    _myRoutesButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_myRoutesButton setTitle:@"My Routes" forState:UIControlStateNormal];
//    [_myRoutesButton setBackgroundColor:buttonColor];
//    _myRoutesButton.layer.cornerRadius = 8.0f;
//    [self.view addSubview:_myRoutesButton];
//    
//    _myRoutesButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [Flurry logEvent:@"My routes tapped"];
//        JCRoutesListViewModel *routesViewModel = [[JCRoutesListViewModel alloc] init];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[routesViewModel loadUserRoutes] subscribeError:^(NSError *error) {
//                    NSLog(@"Error loading my routes");
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                } completed:^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    NSLog(@"Got my routes");
//                    if (routesViewModel.routes.count > 0) {
//                        [routesViewModel setTitle:@"My Routes"];
//                        JCRoutesViewController *routesController = [[JCRoutesViewController alloc] initWithViewModel:routesViewModel];
//                        [self.navigationController pushViewController:routesController animated:YES];
//                    } else {
//                        // No routes
//                        [[JCNotificationManager manager] displayInfoWithTitle:@"No Routes"
//                                                                     subtitle:@"You haven't recorded any routes"
//                                                                         icon:[UIImage imageNamed:@"route-icon"]];
//                    }
//                }];
//            });
//        });
//        return [RACSignal empty];
//    }];
//    
//    // Nearby routes button
//    _nearbyRoutesButton = [[UIButton alloc] init];
//    _nearbyRoutesButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_nearbyRoutesButton setTitle:@"Nearby Routes" forState:UIControlStateNormal];
//    [_nearbyRoutesButton setBackgroundColor:buttonColor];
//    _nearbyRoutesButton.layer.cornerRadius = 8.0f;
//    [self.view addSubview:_nearbyRoutesButton];
//    
//    _nearbyRoutesButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [Flurry logEvent:@"Nearby routes tapped"];
//        JCRoutesListViewModel *routesViewModel = [[JCRoutesListViewModel alloc] init];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            // Do something...
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[routesViewModel loadNearbyRoutes] subscribeError:^(NSError *error) {
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    [[JCNotificationManager manager] displayInfoWithTitle:@"No Routes"
//                                                                 subtitle:@"There are no nearby routes"
//                                                                     icon:[UIImage imageNamed:@"route-icon"]];
//                } completed:^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    NSLog(@"Got nearby routes");
//                    if (routesViewModel.routes.count > 0) {
//                        [routesViewModel setTitle:@"Nearby Routes"];
//                        JCRoutesViewController *routesController = [[JCRoutesViewController alloc] initWithViewModel:routesViewModel];
//                        [self.navigationController pushViewController:routesController animated:YES];
//                    } else {
//                        // No routes
//                        [[JCNotificationManager manager] displayInfoWithTitle:@"No Routes"
//                                                                     subtitle:@"There are no nearby routes"
//                                                                         icon:[UIImage imageNamed:@"route-icon"]];
//                    }
//                }];
//            });
//        });
//        return [RACSignal empty];
//    }];
//    
//    _createRouteButton = [[UIButton alloc] init];
//    _createRouteButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_createRouteButton setTitle:@"Create Route" forState:UIControlStateNormal];
//    [_createRouteButton setBackgroundColor:buttonColor];
//    _createRouteButton.layer.cornerRadius = 8.0f;
//    [self.view addSubview:_createRouteButton];
//
//    _createRouteButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [Flurry logEvent:@"Route capture tapped"];
//        _updateOnAppear = YES;
//        JCRouteCaptureViewController *captureController = [[JCRouteCaptureViewController alloc] init];
//        [self.navigationController pushViewController:captureController animated:YES];
//        return [RACSignal empty];
//    }];

    // Nav
    [self.navigationItem setTitle:@"Profile"];
    [_viewModel.fullNameSignal subscribeNext:^(NSString *fullName) {
        [self.navigationItem setTitle:fullName];
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [_userView autoRemoveConstraintsAffectingView];
    [_userView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_userView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[JCLocationManager manager] startUpdatingCoarse];
    if (_updateOnAppear) {
        [self update];
        _updateOnAppear = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[JCLocationManager manager] locationManager] stopUpdatingLocation];
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
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected a row");
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
    if (!cell) {
        NSLog(@"Making a cell");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuItem"];
    }
    
    return cell;
}


@end
