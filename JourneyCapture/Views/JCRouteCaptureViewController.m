//
//  JCRouteCaptureViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCaptureViewController.h"
#import "JCCaptureView.h"
#import "JCRoutePointViewModel.h"
#import "Flurry.h"

@interface JCRouteCaptureViewController ()
@property (readwrite, nonatomic) BOOL capturing;
@property (strong, nonatomic) NSDate *captureStart;
@end

@implementation JCRouteCaptureViewController

- (id)init
{
    self = [super init];
    if (self) {
        _viewModel = [[JCRouteViewModel alloc] init];
        [self startRoute];
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    _captureView = [[JCCaptureView alloc] initWithViewModel:_viewModel];
    _captureView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _captureView.captureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Tapped capture finish button");
        [self endRoute];
        return [RACSignal empty];
    }];

    [self.view addSubview:_captureView];
}

- (void)viewWillLayoutSubviews
{
    [_captureView autoRemoveConstraintsAffectingView];
    [_captureView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_captureView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    
    [_captureView layoutSubviews];
    
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Capture"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    RACSignal *foregroundSignal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil];

    @weakify(self);
    [foregroundSignal subscribeNext:^(id x) {
        @strongify(self);
        [self scheduleWarningNotification];
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Route Capture

- (void)startRoute
{
    [Flurry logEvent:@"Route Capture" timed:YES];
    _capturing = YES;
    _captureStart = [NSDate date];
    
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
    [[JCLocationManager sharedManager] startUpdatingNav];
    [[JCLocationManager sharedManager] setDelegate:self];
    
    // Set warning notifications in case user forgets to stop capture
    [self scheduleWarningNotification];
}

- (void)endRoute
{
    [self cancelWarningNotification];
    
    // Only allow routes with captured locations
    if (_viewModel.points.count == 0) {
        UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Stop Capturing"
                                                              message:@"No data has been collected, stop capturing?"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Keep Going"
                                                    otherButtonTitles:@"Stop Capturing", nil];
        [cancelAlert show];
        cancelAlert.delegate = self;
    } else {
        // Stop capturing
        [Flurry endTimedEvent:@"Route Capture" withParameters:@{@"completed": @YES}];
        [Flurry logEvent:@"Route Submit"];
        [[[JCLocationManager sharedManager] locationManager] stopUpdatingLocation];
        [[JCLocationManager sharedManager] setDelegate:nil];
        
        // Upload
        [[_viewModel uploadRoute] subscribeError:^(NSError *error) {
            NSLog(@"Upload failed");
        } completed:^{
            NSLog(@"Upload completed");
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

/*
 * Add location to route being captured
 */
- (void)didUpdateLocations:(NSArray *)locations
{
    int numLocations = (int)locations.count;
    for(int i = numLocations-1; i >= 0; i--) {
        NSLog(@"Got new location, adding to the route");
        CLLocation *latestLocation = locations[i];

        if ([_captureStart compare:latestLocation.timestamp] == NSOrderedDescending) {
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
        [_viewModel addPoint:point];

        // Update route line on mapview
        [_captureView updateRouteLine];
    }
}

#pragma mark - Notifications

- (void)scheduleWarningNotification
{
    // Ensure we don't schedule too many
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    // Capturing - Schedule notifications in case the user forgets to stop capturing
    int oneHour = 60 * 60; // seconds
    NSDate *notificatinTime = [NSDate dateWithTimeIntervalSinceNow:oneHour];

    for (int i = 0; i < 2; i++) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = notificatinTime;
        notification.alertBody = @"You are still capturing a route.";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        notificatinTime = [notificatinTime dateByAddingTimeInterval:oneHour];
    }
}

- (void)cancelWarningNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return tableView.frame.size.height / 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"StatsCell";
//
//    JCStatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[JCStatCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                 reuseIdentifier:CellIdentifier];
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    if (indexPath.row == 0) {
//        [[cell statName] setText:@"Current Speed"];
//        double currentSpeedMph = _viewModel.currentSpeed;
//        double currentSpeedKph = (currentSpeedMph * 60 * 60) / 1000;
//        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f kph", currentSpeedKph]];
//    } else if (indexPath.row == 1) {
//        [[cell statName] setText:@"Average Speed"];
//        double averageSpeedMps = _viewModel.averageSpeed;
//        double averageSpeedKph = (averageSpeedMps * 60 * 60) / 1000;
//        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f kph", averageSpeedKph]];
//    } else if (indexPath.row == 2) {
//        [[cell statName] setText:@"Distance"];
//        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f km", _viewModel.totalKm]];
//    }
//    [cell setAccessoryType:UITableViewCellAccessoryNone];
//    return cell;
//}

#pragma mark - UIAlertViewDelgate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        // Stop route capture (route cancel alert)
        [[[JCLocationManager sharedManager] locationManager] stopUpdatingLocation];
        [[JCLocationManager sharedManager] setDelegate:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [Flurry endTimedEvent:@"Route Capture" withParameters:@{@"completed": @NO}];
        [self cancelWarningNotification];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
