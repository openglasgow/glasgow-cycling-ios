//
//  JCRouteViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteViewModel.h"
#import "JCRoutePointViewModel.h"
#import <MapKit/MapKit.h>
#import "JCAPIManager.h"

@implementation JCRouteViewModel
@synthesize currentSpeed, averageSpeed, totalKm, points, routeId,
        safetyRating, difficultyRating, environmentRating,
        estimatedTime, routeImage, name, lastGeocodedKm;

- (id)init
{
    self = [super init];
    if (self) {
        self.points = [[NSMutableArray alloc] init];
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

- (RACSignal *)uploadAll
{
    NSLog(@"Uploading Route");
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self uploadRoute]
         subscribeError:^(NSError *error) {
             // TODO save locally and keep trying
             NSLog(@"Couldn't upload");
             [subscriber sendError:error];
         } completed:^{
             NSLog(@"Route uploaded");
             [subscriber sendNext:nil];
             
             // Upload review
             [[self uploadReview] subscribeError:^(NSError *error) {
                 NSLog(@"Couldn't upload review");
                 [subscriber sendError:error];
             } completed:^{
                 NSLog(@"Review uploaded");
                 [subscriber sendCompleted];
             }];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"Disposed");
        }];
    }];
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
                                              self.routeId = [routeResponse[@"route_id"] integerValue];
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

-(RACSignal *)uploadReview
{
    NSLog(@"Uploading user review");
    JCAPIManager *manager = [JCAPIManager manager];

    NSDictionary *reviewData = @{
                                 @"safety_rating": @(self.safetyRating),
                                 @"difficulty_rating": @(self.difficultyRating),
                                 @"environment_rating": @(self.environmentRating)
                                };

    NSDictionary *routeReview = @{
                                 @"route_id" : @(self.routeId),
                                 @"review" : reviewData
                                };
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (!self.routeId) {
            // TODO send reasonable error
            NSLog(@"Failed to store route review - no route id");
            [subscriber sendError:nil];
        }

        AFHTTPRequestOperation *op = [manager POST:@"/reviews.json"
                                        parameters:routeReview
                                           success:^(AFHTTPRequestOperation *operation, id responseObj) {
                                               // Route stored
                                               NSLog(@"User review stored successfully");
                                               NSLog(@"%@", responseObj);

                                               [subscriber sendCompleted];
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               NSLog(@"User review store failure");
                                               NSLog(@"%@", error);
                                               [subscriber sendError:error];
                                           }
                                      ];

        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

-(RACSignal *)loadPoints
{
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

- (NSNumber *)averageRating
{
    return @((self.environmentRating + self.difficultyRating + self.safetyRating) / 3);
}

- (NSString *)readableTime
{
    int seconds = [self.estimatedTime intValue];
    int hours = seconds / 3600;
    int minutes = (seconds - (hours * 3600)) / 60;
    NSString *minuteDesc = minutes == 1 ? @"minute" : @"minutes";
    NSString *hourDesc = hours == 1 ? @"hour" : @"hours";
    if (hours == 0) {
        return [NSString stringWithFormat:@"Around %d %@", minutes, minuteDesc];
    } else if (minutes == 0) {
        return [NSString stringWithFormat:@"Around %d %@", hours, hourDesc];
    } else {
        return [NSString stringWithFormat:@"Around %d %@ and %2d %@", hours, hourDesc,
                minutes, minuteDesc];
    }
}

@end
