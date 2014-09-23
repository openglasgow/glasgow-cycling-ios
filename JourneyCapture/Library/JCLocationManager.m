//
//  JCLocationManager.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCLocationManager.h"

@implementation JCLocationManager
@synthesize locationManager, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Location manager got location update");
    [self.delegate didUpdateLocations:locations];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO handle user saying no
    NSLog(@"Location error %@", [error localizedDescription]);
}

-(CLLocation *)currentLocation
{
    return self.locationManager.location;
}

-(void)startUpdatingCoarse
{
    // iOS 8+ location auth
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [self.locationManager startUpdatingLocation];
}

-(void)startUpdatingNav
{
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Singleton Methods

+ (JCLocationManager *)sharedManager
{
    static dispatch_once_t pred;
    static JCLocationManager *_manager = nil;

    dispatch_once(&pred, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
@end
