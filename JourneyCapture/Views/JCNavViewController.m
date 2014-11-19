//
//  JCNavViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCNavViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "JCNotificationManager.h"

@interface JCNavViewController ()
@end

@implementation JCNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                // Show not reachable notification
                [[JCNotificationManager manager] displayErrorWithTitle:@"Network Error"
                                                              subtitle:@"There is an issue with either your connection or the server"
                                                                  icon:[UIImage imageNamed:@"connection-issue-icon"]];
            }
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        self.delegate = self;
    }
    return self;
}

#pragma mark - Push

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!self.shouldIgnorePushingViewControllers) {
        self.shouldIgnorePushingViewControllers = YES;
        [super pushViewController:viewController animated:animated];
    }
}

#pragma mark - Private API

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.shouldIgnorePushingViewControllers = NO;
}

@end
