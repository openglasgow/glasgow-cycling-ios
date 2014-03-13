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

#import "JCUserView.h"
#import <QuartzCore/QuartzCore.h>
#import "JCWelcomeViewController.h"
#import "Flurry.h"


#import <GBDeviceInfo/GBDeviceInfo.h>

#import <GSKeychain/GSKeychain.h>

@interface JCUserViewController ()

@end

@implementation JCUserViewController
@synthesize viewModel;
@synthesize myRoutesButton, nearbyRoutesButton, createRouteButton;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [[[JCLocationManager manager] locationManager] startUpdatingLocation];
    [[JCLocationManager manager] setDelegate:self];
    self.viewModel = [[JCUserViewModel alloc] init];
    [[self.viewModel loadDetails] subscribeError:^(NSError *error) {
        NSLog(@"Failed to load user");
    } completed:^{
        NSLog(@"User details loaded");
    }];
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // User details
    JCUserView *detailsView = [[JCUserView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                      viewModel:self.viewModel];
    [self.view addSubview:detailsView];
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    [detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(22);
        make.right.equalTo(self.view.mas_right).with.offset(-22);
        make.top.equalTo(self.view.mas_top).with.offset(navBarHeight + 35); // Extra 20 for status bar
        make.bottom.equalTo(detailsView.settingsButton.mas_bottom).with.offset(15);
    }];

    detailsView.settingsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        IASKAppSettingsViewController *settingsVC = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView"
                                                                                                     bundle:nil];
        settingsVC.delegate = self;
        settingsVC.showDoneButton = YES;
        settingsVC.showCreditsFooter = NO;
        UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsVC];
        [self.navigationController presentViewController:settingsNav
                                                animated:YES
                                              completion:^{
                                                  NSLog(@"Settings shown");
                                              }];
        return [RACSignal empty];
    }];

    // Background map image view
    UIImage *mapImage = [UIImage imageNamed:@"map"];
    self.mapImageView = [[UIImageView alloc] initWithImage:mapImage];
    [self.view insertSubview:self.mapImageView belowSubview:detailsView];
    [self.mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(detailsView.mas_bottom).with.offset(15);
    }];

    // Buttons
    UIColor *buttonColor = [UIColor colorWithRed:0 green:224.0/255.0 blue:184.0/255.0 alpha:1.0];
    
    // My routes button
    self.myRoutesButton = [[UIButton alloc] init];
    [self.myRoutesButton setTitle:@"My Routes" forState:UIControlStateNormal];
    [self.myRoutesButton setBackgroundColor:buttonColor];
    self.myRoutesButton.layer.cornerRadius = 8.0f;
    [self.view addSubview:self.myRoutesButton];
    
    [self.myRoutesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapImageView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(22);
        make.right.equalTo(self.view.mas_right).with.offset(-22);
        make.height.equalTo(@(45));
    }];
    
    self.myRoutesButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [Flurry logEvent:@"Enter My Routes"];
        JCRoutesListViewModel *routesViewModel = [[JCRoutesListViewModel alloc] init];
        [[routesViewModel loadUserRoutes] subscribeError:^(NSError *error) {
            NSLog(@"Error loading my routes");
        } completed:^{
            NSLog(@"Got my routes");
            [routesViewModel setTitle:@"My Routes"];
            JCRoutesViewController *routesController = [[JCRoutesViewController alloc] initWithViewModel:routesViewModel];
            [self.navigationController pushViewController:routesController animated:YES];
        }];
        return [RACSignal empty];
    }];
    
    // Nearby routes button
    self.nearbyRoutesButton = [[UIButton alloc] init];
    [self.nearbyRoutesButton setTitle:@"Nearby Routes" forState:UIControlStateNormal];
    [self.nearbyRoutesButton setBackgroundColor:buttonColor];
    self.nearbyRoutesButton.layer.cornerRadius = 8.0f;
    [self.view addSubview:self.nearbyRoutesButton];
    
    [self.nearbyRoutesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myRoutesButton.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(22);
        make.right.equalTo(self.view.mas_right).with.offset(-22);
        make.height.equalTo(@(45));
    }];
    
    self.nearbyRoutesButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [Flurry logEvent:@"Enter Nearby Routes"];
        JCRoutesListViewModel *routesViewModel = [[JCRoutesListViewModel alloc] init];
        [routesViewModel setTitle:@"Nearby Routes"];
        JCRoutesViewController *routesController = [[JCRoutesViewController alloc] initWithViewModel:routesViewModel];
        [self.navigationController pushViewController:routesController animated:YES];
        return [RACSignal empty];
    }];
    
    self.createRouteButton = [[UIButton alloc] init];
    [self.createRouteButton setTitle:@"Create Route" forState:UIControlStateNormal];
    [self.createRouteButton setBackgroundColor:buttonColor];
    self.createRouteButton.layer.cornerRadius = 8.0f;
    [self.view addSubview:self.createRouteButton];
    
    [self.createRouteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nearbyRoutesButton.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(22);
        make.right.equalTo(self.view.mas_right).with.offset(-22);
        make.height.equalTo(@(80));
    }];

    self.createRouteButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [Flurry logEvent:@"Enter Route Capture"];
        JCRouteCaptureViewController *captureController = [[JCRouteCaptureViewController alloc] init];
        [self.navigationController pushViewController:captureController animated:YES];
        return [RACSignal empty];
    }];

    // Nav
    [self.navigationItem setTitle:@"Profile"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logout
{
    JCWelcomeViewController *welcomeController = [[JCWelcomeViewController alloc] init];
    NSArray *viewControllerStack = @[welcomeController];
    [self.navigationController setViewControllers:viewControllerStack];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[[JCLocationManager manager] locationManager] stopUpdatingLocation];
}

- (void)didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Got locations in user overview");
    [[[JCLocationManager manager] locationManager] stopUpdatingLocation];
}

- (NSString *)settingsViewController:(id<IASKViewController>)settingsViewController mailComposeBodyForSpecifier:(IASKSpecifier *)specifier
{
    GBDeviceDetails *deviceDetails = [GBDeviceInfo
                                      deviceDetails];

    NSString *iosVersion = [NSString stringWithFormat:@"%lu.%lu",
                            (unsigned long)deviceDetails.majoriOSVersion,
                            (unsigned long)deviceDetails.minoriOSVersion];
    return [NSString stringWithFormat:@"**********\niOS Version: %@\nDevice: %@\n**********", iosVersion, deviceDetails.modelString];
}

-(void)settingsViewControllerDidEnd:(IASKAppSettingsViewController *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:^{
                                                      NSLog(@"Dismissed settings");
                                                  }];
}

- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForSpecifier:(IASKSpecifier *)specifier
{
    if ([[specifier key] isEqualToString:@"logout"])
    {
        [[GSKeychain systemKeychain] removeAllSecrets];
        [self.navigationController dismissViewControllerAnimated:NO
                                                      completion:^{
                                                          NSLog(@"Dismissed settings");
                                                      }];
        [self logout];
    }
}

@end
