//
//  JCAppDelegate.m
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCAppDelegate.h"
#import "JCWelcomeViewController.h"
#import "JCNavViewController.h"
#import "JCUserViewController.h"
#import "JCAPIManager.h"
#import <GSKeychain/GSKeychain.h>
#import "Flurry.h"

@implementation JCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Flurry Analytics Setup
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"DS59KXYYXSP92WR2C527"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    BOOL loggedIn = [[GSKeychain systemKeychain] secretForKey:@"user_token"] != nil;
    UIViewController *rootController;
    if (loggedIn) {
        rootController = [[JCUserViewController alloc] init];
    } else {
        rootController = [[JCWelcomeViewController alloc] init];
    }
    JCNavViewController *navController = [[JCNavViewController alloc] initWithRootViewController:rootController];
    [self.window setRootViewController:navController];

    [[JCAPIManager manager] setNavController:navController];

    // Core Data
    [MagicalRecord setupAutoMigratingCoreDataStack];
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
