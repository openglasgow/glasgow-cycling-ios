//
//  JCRoutePointViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRoutePointViewModel.h"
#import "Flurry.h"

@implementation JCRoutePointViewModel
@synthesize location, streetName;

-(NSDictionary *)data
{
    NSMutableDictionary *pointData = [NSMutableDictionary dictionaryWithDictionary:@{
             @"lat": @(self.location.coordinate.latitude),
             @"long": @(self.location.coordinate.longitude),
             @"kph": @(self.location.speed),
             @"altitude": @(self.location.altitude),
             @"time": @([self.location.timestamp timeIntervalSince1970]),
             @"vertical_accuracy": @(self.location.verticalAccuracy),
             @"horizontal_accuracy": @(self.location.horizontalAccuracy),
             @"course": @(self.location.course)
            }];

    if (self.streetName && self.streetName.length > 0) {
        pointData[@"street_name"] = self.streetName;
    }

    return pointData;
}

-(void)reverseGeocode
{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:self.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error) {
                           [Flurry logEvent:@"Geocode Failure" withParameters:@{@"error": error.localizedDescription}];
                           return;
                       }
                       [Flurry logEvent:@"Geocode Success"];

                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       NSLog(@"%@", [placemark.addressDictionary allKeys]);
                       self.streetName = placemark.name;
                       NSLog(@"I am currently at %@",self.streetName);
                   }];
}
@end
