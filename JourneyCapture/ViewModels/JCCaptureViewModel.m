//
//  JCCaptureViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 08/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCaptureViewModel.h"
#import "JCAPIManager.h"

@implementation JCCaptureViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lastGeocodedKm = 0;
    }
    return self;
}

-(void)addPoint:(JCRoutePointViewModel *)point
{
    [self.points addObject:point];

    // Calculate total distance
    if (self.points.count > 1) {
        self.totalKm = 0;
        for (int i = 0; i < self.points.count - 1; i++) {
            JCRoutePointViewModel *thisPoint = self.points[i];
            JCRoutePointViewModel *nextPoint = self.points[i+1];
            CLLocation *firstLoc = thisPoint.location;
            CLLocation *nextLoc = nextPoint.location;
            self.totalKm += ([nextLoc distanceFromLocation:firstLoc] / 1000.0);
        }
    }

    if (self.totalKm > (self.lastGeocodedKm + 0.1)) {
        [point reverseGeocode];
        self.lastGeocodedKm = self.totalKm;
    }

    // Geocode every 100m

    // Calculate current speed
    if (self.points.count > 0) {
        JCRoutePointViewModel *lastPoint = self.points.lastObject;
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
    if (self.points.count > 0) {
        for (int i = 0; i < self.points.count; i++) {
            JCRoutePointViewModel *point = self.points[i];
            totalSpeed += point.location.speed;
        }
        double avgSpeed = totalSpeed / self.points.count;
        if (avgSpeed > 0) {
            self.averageSpeed = avgSpeed;
        } else {
            self.averageSpeed = 0;
        }
    }
}

- (RACSignal *)uploadRoute
{
    NSLog(@"Uploading user route");
    JCAPIManager *manager = [JCAPIManager manager];

    NSMutableArray *pointsData = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.points.count; i++) {
        JCRoutePointViewModel *point = self.points[i];
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
