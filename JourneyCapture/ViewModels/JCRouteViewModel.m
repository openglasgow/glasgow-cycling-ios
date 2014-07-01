//
//  JCRouteViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteViewModel.h"
#import "JCRoutePointViewModel.h"
#import "JCAPIManager.h"
#import "CLLocation+Bearing.h"

@implementation JCRouteViewModel

- (RACSignal *)readableInstanceCount
{
   return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [RACObserve(self, numInstances) subscribeNext:^(NSNumber *numInstances) {
            [subscriber sendNext:[NSString stringWithFormat:@"%d uses", [numInstances intValue]]];
        }];
        return nil;
    }];
}

-(RACSignal *)loadPoints
{
    if (self.points.count > 0) {
        return [RACSignal empty];
    }
    
    NSLog(@"Loading route points");
    JCAPIManager *manager = [JCAPIManager manager];

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (!self.routeId) {
            // TODO send reasonable error
            NSLog(@"Failed to store route review - no route id");
            [subscriber sendError:nil];
        }

        NSString *routeURI = [NSString stringWithFormat:@"/routes/find/%ld.json", (long)self.routeId];
        AFHTTPRequestOperation *op = [manager GET:routeURI
                                        parameters:nil
                                           success:^(AFHTTPRequestOperation *operation, NSDictionary *routeData) {
                                               // Route stored
                                               NSLog(@"Got route points successfully");
                                               NSLog(@"%@", routeData);

                                               NSArray *routePoints = routeData[@"points"];
                                               for (NSDictionary *routePoint in routePoints) {
                                                   JCRoutePointViewModel *point = [[JCRoutePointViewModel alloc] init];
                                                   NSNumber *speedNum = routePoint[@"speed"];
                                                   double speed = 0.0;
                                                   if (speedNum != (NSNumber *)[NSNull null]) {
                                                       speed = [speedNum doubleValue];
                                                   }
                                                   double altitude = [routePoint[@"altitude"] doubleValue];
                                                   double lat = [routePoint[@"lat"] doubleValue];
                                                   double lng = [routePoint[@"long"] doubleValue];
                                                   CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
                                                   int timestamp = [routePoint[@"created_at"] intValue];
                                                   NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];

                                                   CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coord
                                                                                                   altitude:altitude
                                                                                         horizontalAccuracy:1
                                                                                           verticalAccuracy:1
                                                                                                     course:0
                                                                                                      speed:speed
                                                                                                  timestamp:date];
                                                   point.location = loc;
                                                   [self.points addObject:point];
                                               }

                                               [subscriber sendCompleted];
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               NSLog(@"Failed to get route points");
                                               NSLog(@"%@", error);
                                               [subscriber sendError:error];
                                           }
                                      ];

        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

- (CLLocationCoordinate2D)startCircleCoordinate
{
    JCRoutePointViewModel *startPoint = self.points.firstObject;
    int nextIndex = ceil(self.points.count/10);
    JCRoutePointViewModel *nextPoint = self.points[nextIndex];
    CLLocationDirection bearing = [startPoint.location bearingToLocation:nextPoint.location] + 180;
    
    double bearingRadians = (bearing * M_PI) / 180;
    return [self locationWithBearing:bearingRadians
                            distance:150.0 fromLocation:startPoint.location.coordinate];
}

- (CLLocationCoordinate2D)endCircleCoordinate
{
    JCRoutePointViewModel *endPoint = self.points.lastObject;
    NSInteger nextIndex = self.points.count - ceil(self.points.count/10) - 1;
    if (nextIndex > (self.points.count - 1)) {
        nextIndex = self.points.count - 2;
    }
    if (nextIndex < 0) {
        nextIndex = 0;
    }
    JCRoutePointViewModel *nextPoint = self.points[nextIndex];
    CLLocationDirection bearing = [endPoint.location bearingToLocation:nextPoint.location] + 180;
    
    double bearingRadians = (bearing * M_PI) / 180;
    
    return [self locationWithBearing:bearingRadians
                            distance:150.0 fromLocation:endPoint.location.coordinate];
}

- (CLLocationCoordinate2D)locationWithBearing:(float)bearing distance:(float)distanceMeters fromLocation:(CLLocationCoordinate2D)origin
{
    CLLocationCoordinate2D target;
    const double distRadians = distanceMeters / (6372797.6); // earth radius in meters
    
    float lat1 = origin.latitude * M_PI / 180;
    float lon1 = origin.longitude * M_PI / 180;
    
    float lat2 = asin( sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing));
    float lon2 = lon1 + atan2( sin(bearing) * sin(distRadians) * cos(lat1),
                              cos(distRadians) - sin(lat1) * sin(lat2) );
    
    target.latitude = lat2 * 180 / M_PI;
    target.longitude = lon2 * 180 / M_PI; // no need to normalize a heading in degrees to be within -179.999999° to 180.00000°
    
    return target;
}

- (void)submitReview
{
    NSLog(@"Submitting review of %f", self.rating);
    JCAPIManager *manager = [JCAPIManager manager];
    NSDictionary *reviewParams = @{
                                   @"route_id": @(_routeId),
                                   @"rating": @(self.rating)
                                   };
    [manager POST:@"/review.json"
       parameters:reviewParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Review submitted successfully");
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Review submision failed");
          }];
}

@end
