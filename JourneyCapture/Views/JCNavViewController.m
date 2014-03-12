//
//  JCNavViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCNavViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <CRToast/CRToast.h>

@interface JCNavViewController ()
@property (readwrite, nonatomic) BOOL networkErrorShown;
@end

@implementation JCNavViewController
@synthesize networkErrorShown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable && !self.networkErrorShown) {
                // Show not reachable notification
                self.networkErrorShown = YES;
                NSDictionary *options = @{
                                          kCRToastTextKey : @"Network Error",
                                          kCRToastFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                            size:18.0],
                                          kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                          kCRToastSubtitleTextKey : @"There is an issue with either your connection or the server",
                                          kCRToastSubtitleFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                                    size:12.0],
                                          kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentLeft),
                                          kCRToastBackgroundColorKey : [UIColor colorWithRed:(231/255.0)
                                                                                       green:(32./255.0)
                                                                                        blue:(73.0/255.0)
                                                                                       alpha:1.0],
                                          kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                          kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                          kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                          kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                          kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                          kCRToastTimeIntervalKey : @3,
                                          kCRToastImageKey : [UIImage imageNamed:@"lock-50"]
                                        };

                [CRToastManager showNotificationWithOptions:options
                                            completionBlock:^{
                                                NSLog(@"Network error notification shown");
                                                self.networkErrorShown = NO;
                                            }];
            }
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
