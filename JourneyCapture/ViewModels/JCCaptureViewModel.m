//
//  JCCaptureViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 08/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCaptureViewModel.h"
#import "JCAPIManager.h"
#import "Route.h"
#import "RoutePoint.h"
#import "Flurry.h"

@implementation JCCaptureViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastGeocodedKm = 0;
        _totalKm = 0;
        
        _route = [Route MR_createEntity];
        NSLog(@"Create route - %lu now in queue", (unsigned long)[Route MR_countOfEntities]);
    }
    return self;
}

- (instancetype)initWithModel:(Route *)routeModel
{
    return self;
}

- (NSOrderedSet *)points
{
    return _route.points;
}

- (void)addLocation:(CLLocation *)location
{
    double speedKph = (location.speed * 60 * 60) / 1000;
    
    // Add RoutePoint model
    RoutePoint *routePoint = [RoutePoint MR_createEntity];
    routePoint.lat = @(location.coordinate.latitude);
    routePoint.lng = @(location.coordinate.longitude);
    routePoint.altitude = @(location.altitude);
    routePoint.verticalAccuracy = @(location.verticalAccuracy);
    routePoint.horizontalAccuracy = @(location.horizontalAccuracy);
    routePoint.course = @(location.course);
    routePoint.kph = @(speedKph);
    routePoint.time = location.timestamp;
    
    [_route addPointsObject:routePoint];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saved route point");
    }];
    
    // Calculate total distance
    if (_route.points.count > 1) {
        RoutePoint *previousPoint = _route.points[_route.points.count - 2];
        CLLocation *previousLocation = [[CLLocation alloc] initWithLatitude:previousPoint.lat.doubleValue
                                                                  longitude:previousPoint.lng.doubleValue];
        
        RoutePoint *thisPoint = _route.points[_route.points.count - 1];
        CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:thisPoint.lat.doubleValue
                                                              longitude:thisPoint.lng.doubleValue];
        
        double latestDistance = [thisLocation distanceFromLocation:previousLocation] / 1000.0f;
        
        [self setTotalKm:_totalKm + latestDistance];
    }

    // Geocode point every 100m
    if (self.totalKm > (_lastGeocodedKm + 0.1)) {
        _lastGeocodedKm = self.totalKm;
        CLGeocoder *geocoder = [CLGeocoder new];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           if (error) {
                               [Flurry logEvent:@"Geocode Failure" withParameters:@{@"error": error.localizedDescription}];
                               return;
                           }
                           [Flurry logEvent:@"Geocode Success"];
                           
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           NSLog(@"%@", [placemark.addressDictionary allKeys]);
                           routePoint.streetName = placemark.name;
                           NSLog(@"I am currently at %@", routePoint.streetName);
                           [[NSManagedObjectContext MR_defaultContext]
                            MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                               NSLog(@"Saved route point");
                           }];
                       }];
    }


    // Calculate current speed
    if (location.speed > 0) {
        [self setCurrentSpeed:speedKph];
    } else {
        [self setCurrentSpeed:0];
    }

    // Calculate average speed
    if (_route.points.count > 0) {
        double totalSpeed = 0.0;
        for (RoutePoint *point in _route.points) {
            totalSpeed += [point.kph doubleValue];
        }
        double avgSpeed = totalSpeed / _route.points.count;
        if (avgSpeed > 0) {
            [self setAverageSpeed:avgSpeed];
        } else {
            [self setAverageSpeed:0];
        }
    }
}

- (void)completeRoute {
    _route.completed = @YES;
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saved route point");
    }];
}

- (RACSignal *)uploadRoute
{
    NSLog(@"Uploading user route");
    JCAPIManager *manager = [JCAPIManager manager];

    NSMutableArray *pointsData = [[NSMutableArray alloc] init];
    for (RoutePoint *point in _route.points) {
        [pointsData addObject:@{
                                @"lat": point.lat,
                                @"long": point.lng,
                                @"kph": point.kph,
                                @"altitude": point.altitude,
                                @"time": @([point.time timeIntervalSince1970]),
                                @"vertical_accuracy": point.verticalAccuracy,
                                @"horizontal_accuracy": point.horizontalAccuracy,
                                @"course": point.course,
                                @"street_name": point.streetName
                                }];
    }

    NSDictionary *routeData = @{ @"points" : pointsData };
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager POST:@"/routes.json"
                                        parameters:routeData
                                           success:^(AFHTTPRequestOperation *operation, NSDictionary *routeResponse) {
                    // Route stored
                    NSLog(@"User route stored successfully");
                    NSLog(@"%@", routeResponse);
                    _routeId = [routeResponse[@"route_id"] integerValue];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"User route store failure");
                    NSLog(@"%@", error);
                    [subscriber sendError:error];
                }
        ];

        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

@end
