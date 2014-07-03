//
//  JCUserManager.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserManager.h"
#import <GSKeychain/GSKeychain.h>
#import "JCSigninViewController.h"
#import "JCAPIManager.h"
#import "JCNotificationManager.h"
#import "User.h"
#import "Route.h"
#import "RoutePoint.h"

@implementation JCUserManager

- (void)logout {
    // Remove auth details
    [[GSKeychain systemKeychain] removeAllSecrets];
    
    // Remove any cookies for the API
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:API_URI]];
    for (NSHTTPCookie* cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    // Remove user cache
    [User MR_truncateAll];
    [Route MR_truncateAll];
    [RoutePoint MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    // Show login screen and a logout notification
    if (_navVC) {
        JCSigninViewController *welcomeVC = [[JCSigninViewController alloc] init];
        [_navVC setViewControllers:@[welcomeVC] animated:NO];
    }
}

- (void)refreshToken {
    NSString *refreshToken = [[GSKeychain systemKeychain] secretForKey:@"refresh_token"];
    if (!refreshToken) {
        [[JCNotificationManager manager] displayErrorWithTitle:@"Logged Out"
                                                      subtitle:@"Confirm your details to log in again"
                                                          icon:[UIImage imageNamed:@"logged-out-icon"]];
        [self logout];
    }
    
    JCAPIManager *manager = [JCAPIManager manager];
    NSDictionary *refreshParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                  CLIENT_ID, @"client_id",
                                  CLIENT_SECRET, @"client_secret",
                                  @"refresh_token", @"grant_type",
                                  refreshToken, @"refresh_token",
                                  nil];
    [manager POST:@"/oauth/token" parameters:refreshParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Token details successfully retrieved");
              NSLog(@"Signin success");
              NSLog(@"%@", responseObject);
              NSString *accessToken = [responseObject objectForKey:@"access_token"];
              NSString *refreshToken = [responseObject objectForKey:@"refresh_token"];
              if (accessToken) {
                  [[GSKeychain systemKeychain] setSecret:accessToken forKey:@"access_token"];
              }
              
              if (refreshToken) {
                  [[GSKeychain systemKeychain] setSecret:refreshToken forKey:@"refresh_token"];
              }
              
              if (!accessToken && !refreshToken) {
                  [self logout];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[JCNotificationManager manager] displayErrorWithTitle:@"Logged Out"
                                                            subtitle:@"Confirm your details to log in again"
                                                                icon:[UIImage imageNamed:@"logged-out-icon"]];
              [self logout];
          }];
}

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    static dispatch_once_t pred;
    static JCUserManager *_sharedManager = nil;
    
    dispatch_once(&pred, ^{
        _sharedManager = [self new];
    });
    return _sharedManager;
}

@end
