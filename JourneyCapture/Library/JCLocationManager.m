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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Got %lu updated locations", (unsigned long)[locations count]);
    [self.delegate didUpdateLocations:locations];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO handle user saying no
    NSLog(@"Location error");
}

-(CLLocation *)currentLocation
{
    return self.locationManager.location;
}

#pragma mark - Singleton Methods

+ (JCLocationManager *)manager
{
    static dispatch_once_t pred;
    static JCLocationManager *_manager = nil;

    dispatch_once(&pred, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
@end
