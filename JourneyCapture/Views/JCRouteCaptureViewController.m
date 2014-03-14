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
#import "Flurry.h"

@interface JCRouteCaptureViewController ()

@end

@implementation JCRouteCaptureViewController
@synthesize viewModel, captureView, captureStart;

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
            [Flurry logEvent:@"Route Capture" timed:YES];

            // Start
            self.captureStart = [NSDate date];
            [self.captureView transitionToActive];

            // Show cancel button in place of back button
            self.navigationItem.hidesBackButton = YES;
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
            self.navigationItem.leftBarButtonItem = cancelButton;
            cancelButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Stop Capturing"
                                                                      message:@"Are you sure you want to stop capturing the route?"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Keep Going"
                                                            otherButtonTitles:@"Stop Capturing", nil];
                [cancelAlert show];
                cancelAlert.delegate = self;
                return [RACSignal empty];
            }];

            // Start updating location
            [[JCLocationManager manager] startUpdatingNav];
            [[JCLocationManager manager] setDelegate:self];
        } else if ([[self.captureView.captureButton.titleLabel text] isEqualToString:@"Stop"]) {
            // Stop
            if (self.viewModel.points.count == 0) {
                UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Stop Capturing"
                                                                      message:@"No data has been collected, stop capturing?"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Keep Going"
                                                            otherButtonTitles:@"Stop Capturing", nil];
                [cancelAlert show];
                cancelAlert.delegate = self;
            } else {
                [Flurry endTimedEvent:@"Route Capture" withParameters:@{@"completed": @YES}];
                [Flurry logEvent:@"Route Submit" timed:YES];
                [[[JCLocationManager manager] locationManager] stopUpdatingLocation];
                [[JCLocationManager manager] setDelegate:nil];
                [self.captureView transitionToComplete];
            }
        } else {
            // Submit
            [Flurry endTimedEvent:@"Route Submit" withParameters:@{
                                                                   @"Safety Rating": @(self.viewModel.safetyRating),
                                                                   @"Environment Rating": @(self.viewModel.environmentRating),
                                                                   @"Difficulty Rating": @(self.viewModel.difficultyRating)
                                                                   }];
            [[self.viewModel uploadRoute] subscribeError:^(NSError *error) {
                // TODO save locally and keep trying
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
    int numLocations = (int)locations.count;
    for(int i = numLocations-1; i >= 0; i--) {
        NSLog(@"Got new location, adding to the route");
        CLLocation *latestLocation = locations[i];

        if ([self.captureStart compare:latestLocation.timestamp] == NSOrderedDescending) {
            // Location is older than start
            NSLog(@"Filtered old location");
            return;
        }

        if (latestLocation.horizontalAccuracy > 65) {
            // 65 is WiFi accuracy
            NSLog(@"Horizontal accuracy too low (%f), filtered", latestLocation.horizontalAccuracy);
            return;
        }

        // Create point
        JCRoutePointViewModel *point = [[JCRoutePointViewModel alloc] init];
        point.location = latestLocation;
        [self.viewModel addPoint:point];

        // Update route line on mapview
        [self.captureView updateRouteLine];

        // Reload stats
        [self.captureView.statsTable reloadData];
    }
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
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        // Stop
        [[[JCLocationManager manager] locationManager] stopUpdatingLocation];
        [[JCLocationManager manager] setDelegate:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [Flurry endTimedEvent:@"Route Capture" withParameters:@{@"completed": @NO}];;
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
