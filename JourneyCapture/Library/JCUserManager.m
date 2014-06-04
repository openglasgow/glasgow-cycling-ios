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
