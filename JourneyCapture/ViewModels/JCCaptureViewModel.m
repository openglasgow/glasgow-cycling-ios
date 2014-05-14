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

@implementation JCCaptureViewModel
@synthesize currentSpeed, averageSpeed, totalKm; // Synthesis due to RAC quirk

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastGeocodedKm = 0;
        _points = [NSMutableArray new];
        _route = [Route MR_createEntity];
        NSLog(@"Create route - %lu now in queue", (unsigned long)[Route MR_countOfEntities]);
    }
    return self;
}

-(void)addPoint:(JCRoutePointViewModel *)point
{
    [_points addObject:point];

    // Calculate total distance
    if (_points.count > 1) {
        self.totalKm = 0;
        for (int i = 0; i < _points.count - 1; i++) {
            JCRoutePointViewModel *thisPoint = _points[i];
            JCRoutePointViewModel *nextPoint = _points[i+1];
            CLLocation *firstLoc = thisPoint.location;
            CLLocation *nextLoc = nextPoint.location;
            self.totalKm += ([nextLoc distanceFromLocation:firstLoc] / 1000.0f);
        }
    }

    if (self.totalKm > (_lastGeocodedKm + 0.1)) {
        [point reverseGeocode];
        _lastGeocodedKm = self.totalKm;
    }

    // Geocode every 100m

    // Calculate current speed
    if (_points.count > 0) {
        JCRoutePointViewModel *lastPoint = _points.lastObject;
        if (lastPoint.location.speed > 0) {
            self.currentSpeed = lastPoint.location.speed;
        } else {
            self.currentSpeed = 0;
        }
    } else {
        self.currentSpeed = 0;
    }

    // Calculate average speed
    double totalSpeed = 0.0;
    if (_points.count > 0) {
        for (int i = 0; i < _points.count; i++) {
            JCRoutePointViewModel *point = _points[i];
            totalSpeed += point.location.speed;
        }
        double avgSpeed = totalSpeed / _points.count;
        if (avgSpeed > 0) {
            self.averageSpeed = avgSpeed;
        } else {
            self.averageSpeed = 0;
        }
    }
    
    // RoutePoint model
    RoutePoint *routePoint = [RoutePoint MR_createEntity];
    routePoint.lat = @(point.location.coordinate.latitude);
    routePoint.lng = @(point.location.coordinate.longitude);
    routePoint.altitude = @(point.location.altitude);
    routePoint.verticalAccuracy = @(point.location.verticalAccuracy);
    routePoint.horizontalAccuracy = @(point.location.horizontalAccuracy);
    routePoint.course = @(point.location.course);
    routePoint.kph = @((point.location.speed * 60 * 60) / 1000);
    routePoint.streetName = point.streetName;
    routePoint.route = _route;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saved route point");
    }];
}

- (RACSignal *)uploadRoute
{
    NSLog(@"Uploading user route");
    JCAPIManager *manager = [JCAPIManager manager];

    NSMutableArray *pointsData = [[NSMutableArray alloc] init];
    for (int i = 0; i < _points.count; i++) {
        JCRoutePointViewModel *point = _points[i];
        [pointsData addObject:point.data];
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
