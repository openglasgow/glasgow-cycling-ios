//
//  JCRouteCaptureViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCaptureViewModel.h"
#import "JCRoutePointViewModel.h"
#import <MapKit/MapKit.h>
#import "JCAPIManager.h"

@implementation JCRouteCaptureViewModel
@synthesize currentSpeed, averageSpeed, totalMetres, points, routeId,
        safetyRating, difficultyRating, environmentRating;

- (id)init
{
    self = [super init];
    if (self) {
        self.points = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addPoint:(JCRoutePointViewModel *)point
{
    [self.points addObject:point];

    // Calculate total distance
    if (self.points.count > 1) {
        self.totalMetres = 0;
        for (int i = 0; i < self.points.count - 1; i++) {
            JCRoutePointViewModel *thisPoint = self.points[i];
            JCRoutePointViewModel *nextPoint = self.points[i+1];
            CLLocation *firstLoc = thisPoint.location;
            CLLocation *nextLoc = nextPoint.location;
            self.totalMetres += [nextLoc distanceFromLocation:firstLoc];
        }
    }

    // Calculate current speed
    if (self.points.count > 0) {
        JCRoutePointViewModel *lastPoint = self.points.lastObject;
        self.currentSpeed = lastPoint.location.speed;
    } else {
        self.currentSpeed = 0;
    }

    // Calculate average speed
    double totalSpeeds = 0.0;
    if (self.points.count > 0) {
        for (int i = 0; i < self.points.count; i++) {
            JCRoutePointViewModel *point = self.points[i];
            totalSpeeds += point.location.speed;
        }
        self.averageSpeed = totalSpeeds / self.points.count;
    }
}

-(RACSignal *)uploadRoute
{
    NSLog(@"Loading user routes");
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
    NSLog(@"Loading user routes");
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

@end
