//
//  JCSearchJourneyListViewModel.m
//  JourneyCapture
//
//  Created by Michael Hayes on 20/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSearchJourneyListViewModel.h"
#import "JCAPIManager.h"

@implementation JCSearchJourneyListViewModel
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    self.title = @"Search";
    self.noItemsError = @"No routes found";
    
    return self;
}

- (RACSignal *)setDestWithAddressString:(NSString *)dest
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:dest
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if([placemarks count]) {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             CLLocation *location = placemark.location;
                             _destCoord = location.coordinate;
                             [subscriber sendCompleted];
                         } else {
                             NSLog(@"error");
                             [subscriber sendError:error];
                         }
                     }];
        
        return [RACDisposable disposableWithBlock:^{
            [geocoder cancelGeocode];
        }];
    }];
}

#pragma mark - JCJourneyListViewModel

- (NSDictionary *)searchParams
{
    CLLocationCoordinate2D userCoords = [[JCLocationManager sharedManager] currentLocation].coordinate;
    
    return @{
             @"source_lat": @(userCoords.latitude),
             @"source_long": @(userCoords.longitude),
             @"dest_lat": @(_destCoord.latitude),
             @"dest_long": @(_destCoord.longitude),
             };
}
@end
