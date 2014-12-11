//
//  JCRouteCaptureViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCaptureViewController.h"
#import "JCCaptureView.h"
#import "JCCaptureViewModel.h"
#import "JCRoutePointViewModel.h"

@interface JCRouteCaptureViewController ()
@property (readwrite, nonatomic) BOOL capturing;
@property (strong, nonatomic) NSDate *captureStart;
@end

@implementation JCRouteCaptureViewController

- (id)init
{
    self = [super init];
    if (self) {
        _viewModel = [JCCaptureViewModel new];
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
    CLS_LOG(@"Route Capture VC Loaded");
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Route Capture

- (void)startRoute
{
    CLS_LOG(@"Starting route capture");
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
    [[JCLocationManager sharedManager] setDelegate:self];
    [[JCLocationManager sharedManager] startUpdatingNav];
    
    // Set warning notifications in case user forgets to stop capture
    [self scheduleWarningNotification];
}

- (void)endRoute
{
    NSLog(@"Ending route");
    
    // Only allow routes with captured locations
    if (_viewModel.points.count == 0) {
        UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Stop Capturing"
                                                              message:@"No data has been collected, stop capturing?"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Keep Going"
                                                    otherButtonTitles:@"Stop Capturing", nil];
        [cancelAlert show];
        cancelAlert.delegate = self;
    } else if (_viewModel.totalKm < 0.5) {
        NSString *errorString = [NSString stringWithFormat:@"The route needs to be %.1fm longer as it will be trimmed for privacy reasons", (0.5 - _viewModel.totalKm) * 1000];
        UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Route Too Short"
                                                              message:errorString
                                                             delegate:nil
                                                    cancelButtonTitle:@"Keep Going"
                                                    otherButtonTitles:@"Discard Route", nil];
        [cancelAlert show];
        _alertDisposable = [RACObserve(self, viewModel.totalKm) subscribeNext:^(id x) {
            if (![cancelAlert isHidden]) {
                if (_viewModel.totalKm >= 0.5) {
                    // Submit route
                    [cancelAlert dismissWithClickedButtonIndex:0 animated:NO];
                    [self submitRoute];
                } else {
                    // Show error: too short
                    float distanceToGo = (0.5 - _viewModel.totalKm) * 1000;
                    if (distanceToGo < 0) {
                        distanceToGo = 0;
                    }
                    NSString *errorString = [NSString stringWithFormat:@"The route needs to be %.1fm longer as it will be trimmed for privacy reasons", distanceToGo];
                    cancelAlert.message = errorString;
                }
            }
        }];
        cancelAlert.delegate = self;
    } else {
        [self submitRoute];
    }
}

- (void)submitRoute {
    // Stop capturing
    CLS_LOG("Ended route capture, submitting");
    int numPoints = (int)_viewModel.points.count;
    [Crashlytics setIntValue:numPoints forKey:@"Num Route Points"];
    
    [[[JCLocationManager sharedManager] locationManager] stopUpdatingLocation];
    [[JCLocationManager sharedManager] setDelegate:nil];
    
    // Set route as completed
    [_viewModel setCompleted];
    [self.navigationController popViewControllerAnimated:YES];
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

        // Add location to route
        [_viewModel addLocation:latestLocation];

        // Update route line on mapview
        [_captureView updateRouteLine];
    }
}

#pragma mark - Notifications

- (void)scheduleWarningNotification
{
    // Capturing - Schedule notifications in case the user forgets to stop capturing
    NSDate *notificatinTime = [NSDate dateWithTimeIntervalSinceNow:10];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = notificatinTime;
    notification.alertBody = @"You are still capturing a route.";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 0;
    notification.repeatInterval = NSCalendarUnitSecond;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - UIAlertViewDelgate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Stop route capture (route cancel alert)
        NSLog(@"Cancelling route");
        [[[JCLocationManager sharedManager] locationManager] stopUpdatingLocation];
        [[JCLocationManager sharedManager] setDelegate:nil];
        [self.navigationController popViewControllerAnimated:YES];
        CLS_LOG(@"Cancelled route capture");
    }
    if (_alertDisposable) {
        [_alertDisposable dispose];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
