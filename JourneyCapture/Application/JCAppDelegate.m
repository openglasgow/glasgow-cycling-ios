//
//  JCAppDelegate.m
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCAppDelegate.h"
#import "JCSigninViewController.h"
#import "JCNavViewController.h"
#import "JCUserViewController.h"
#import "JCAPIManager.h"
#import "JCUserManager.h"
#import <GSKeychain/GSKeychain.h>
#import "Flurry.h"
#import "UIImage+color.h"

@implementation JCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if !TARGET_IPHONE_SIMULATOR
    //Flurry Analytics Setup - Crash reporting handled by Hockey App
    [Flurry setSecureTransportEnabled:YES];
    [Flurry startSession:@"DDFSMM7RXYZNTB298YW3"];
    
    //Hockey App Setup
#ifdef BETA
#ifndef DEBUG
    [Flurry setCrashReportingEnabled:NO];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"934359ffd9d098406d81187e2348cb09"
                                                           delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:BITAuthenticatorIdentificationTypeDevice];
#endif
#else
    [Flurry setCrashReportingEnabled:YES];
#endif
#endif
    
    // Core Data
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"JourneyModel"];
    
    // Present correct VC
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Show the appropriate screen
    BOOL loggedIn = [[GSKeychain systemKeychain] secretForKey:@"access_token"] != nil;
    UIViewController *rootController;
    if (loggedIn) {
        rootController = [[JCUserViewController alloc] init];
    } else {
        rootController = [[JCSigninViewController alloc] init];
    }
    
    JCNavViewController *navController = [[JCNavViewController alloc] initWithRootViewController:rootController];
    [JCUserManager sharedManager].navVC = navController;
    [self.window setRootViewController:navController];
    
    // Nav Bar customisation
    [navController.navigationBar setBarTintColor:[UIColor jc_blueColor]];
    [navController.navigationBar setTranslucent:NO];
    navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    [navController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor jc_blueColor]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navController.navigationBar setShadowImage:[UIImage new]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    navController.navigationBar.tintColor = [UIColor whiteColor];

    // Allow API manager to logout user
    [[JCAPIManager manager] setNavController:navController];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if( [[BITHockeyManager sharedHockeyManager].authenticator handleOpenURL:url
                                                          sourceApplication:sourceApplication
                                                                 annotation:annotation]) {
        return YES;
    }
    
    /* Your own custom URL handlers */
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Cancel any pending notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
