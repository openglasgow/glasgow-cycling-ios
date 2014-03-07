//
//  JCRouteCaptureViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCaptureViewController.h"
#import "JCCaptureView.h"

@interface JCRouteCaptureViewController ()

@end

@implementation JCRouteCaptureViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // User details
    CGRect captureFrame = [[UIScreen mainScreen] applicationFrame];
    JCCaptureView *captureView = [[JCCaptureView alloc] initWithFrame:captureFrame];
    captureView.captureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Tapped capture button");
        if ([[captureView.captureButton.titleLabel text] isEqualToString:@"Start"]) {
            // Start
            [captureView transitionToActive];
        } else {
            // Stop
        }
        return [RACSignal empty];
    }];
    [self.view addSubview:captureView];
}

- (void)didUpdateLocations:(NSArray *)locations
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Capture"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
