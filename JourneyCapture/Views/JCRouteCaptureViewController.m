//
//  JCRouteCaptureViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCaptureViewController.h"
#import "JCCaptureView.h"
#import "JCStatCell.h"
#import "JCRoutePointViewModel.h"

@interface JCRouteCaptureViewController ()

@end

@implementation JCRouteCaptureViewController
@synthesize viewModel, captureView;

- (id)init
{
    self = [super init];
    if (self) {
        self.viewModel = [[JCRouteViewModel alloc] init];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    CGRect captureFrame = [[UIScreen mainScreen] applicationFrame];
    self.captureView = [[JCCaptureView alloc] initWithFrame:captureFrame viewModel:self.viewModel];
    captureView.captureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Tapped capture button");
        if ([[self.captureView.captureButton.titleLabel text] isEqualToString:@"Start"]) {
            // Start
            [self.captureView transitionToActive];
            self.navigationItem.hidesBackButton = YES;
            [[JCLocationManager manager] startUpdatingNav];
            [[JCLocationManager manager] setDelegate:self];
        } else if ([[self.captureView.captureButton.titleLabel text] isEqualToString:@"Stop"]) {
            // Stop
            [[[JCLocationManager manager] locationManager] stopUpdatingLocation];
            [self.captureView transitionToComplete];
        } else {
            // Submit
            [[self.viewModel uploadRoute] subscribeError:^(NSError *error) {
                // TODO save locally and keep trying ?
                NSLog(@"Couldn't upload");
            } completed:^{
                NSLog(@"Route uploaded");
                [[self.viewModel uploadReview] subscribeError:^(NSError *error) {
                    NSLog(@"Couldn't upload review");
                } completed:^{
                    NSLog(@"Review uploaded");
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
        }
        return [RACSignal empty];
    }];

    [self.captureView.statsTable setDelegate:self];
    [self.captureView.statsTable setDataSource:self];

    [self.view addSubview:self.captureView];
}

- (void)didUpdateLocations:(NSArray *)locations
{
    // TODO deal with deferred locations
    NSLog(@"Got new location, adding to the route");
    CLLocation *latestLocation = locations[0];

    // Create point
    JCRoutePointViewModel *point = [[JCRoutePointViewModel alloc] init];
    point.location = latestLocation;
    [self.viewModel addPoint:point];

    // Update route line on mapview
    [self.captureView updateRouteLine];

    // Reload stats
    [self.captureView.statsTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Capture"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.frame.size.height - 400) / 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatsCell";

    JCStatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JCStatCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        [[cell statName] setText:@"Current Speed"];
        double currentSpeedMph = self.viewModel.currentSpeed;
        double currentSpeedKph = (currentSpeedMph * 60 * 60) / 1000;
        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f kph", currentSpeedKph]];
    } else if (indexPath.row == 1) {
        [[cell statName] setText:@"Average Speed"];
        double averageSpeedMps = self.viewModel.averageSpeed;
        double averageSpeedKph = (averageSpeedMps * 60 * 60) / 1000;
        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f kph", averageSpeedKph]];
    } else if (indexPath.row == 2) {
        [[cell statName] setText:@"Distance"];
        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f km", self.viewModel.totalKm]];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
