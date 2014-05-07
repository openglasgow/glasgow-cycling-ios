//
//  JCRoutesListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRoutesListViewModel.h"
#import "JCRouteViewModel.h"
//#import "JCLocationManager.h"

@implementation JCRoutesListViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

//-(RACSignal *)loadNearbyRoutes
//{
//    NSLog(@"Loading user routes");
//    JCAPIManager *manager = [JCAPIManager manager];
//    CLLocation *currentLocation = [[JCLocationManager sharedManager] currentLocation];
//    NSDictionary *locationParams = @{
//                                     @"lat": @(currentLocation.coordinate.latitude),
//                                     @"long": @(currentLocation.coordinate.longitude)
//                                     };
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        AFHTTPRequestOperation *op = [manager GET:@"/routes/nearby.json"
//                                       parameters:locationParams
//                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *routesDict) {
//                                              // Registered, store user token
//                                              _routes = [[NSMutableArray alloc] init];
//
//                                              NSLog(@"Nearby routes load success");
//                                              NSLog(@"%@", routesDict);
//                                              NSArray *routesResponse = routesDict[@"routes"];
//
//                                              [self storeRoutes:routesResponse];
//                                              
//                                              [subscriber sendCompleted];
//                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                              NSLog(@"Nearby routes load failure");
//                                              NSLog(@"%@", error);
//                                              NSLog(@"%@", operation.responseObject);
//                                              [subscriber sendError:error];
//                                          }
//                                      ];
//        
//        return [RACDisposable disposableWithBlock:^{
//            [op cancel];
//        }];
//    }];
//}

- (RACSignal *)loadRoutes
{
    return [RACSignal empty];
}

-(void)storeRoutes:(NSArray *)routesData
{
    for (int i = 0; i < routesData.count; i++) {
        NSDictionary *routeData = routesData[i];
        JCRouteViewModel *route = [[JCRouteViewModel alloc] init];
        NSString *startName = routeData[@"start_name"];
        NSString *endName = routeData[@"end_name"];
        [route setName:[NSString stringWithFormat:@"%@ to %@", startName, endName]];

        [route setUses:[routeData[@"num_routes"] intValue]];
        [route setNumReviews:[routeData[@"num_reviews"] intValue]];
        
        // Average values
        NSDictionary *averages = routeData[@"averages"];
        
        double safetyRating = 0;
        if (averages[@"safety_rating"] != [NSNull null]) {
            safetyRating = [averages[@"safety_rating"] doubleValue];
        }
        [route setSafetyRating:safetyRating];

        double difficultyRating = 0;
        if (averages[@"difficulty_rating"] != [NSNull null]) {
            difficultyRating = [averages[@"difficulty_rating"] doubleValue];
        }
        [route setDifficultyRating:difficultyRating];

        double environmentRating = 0;
        if (averages[@"environment_rating"] != [NSNull null]) {
            environmentRating = [averages[@"environment_rating"] doubleValue];
        }
        [route setSafetyRating:environmentRating];

        double time = 0;
        if (averages[@"time"] != [NSNull null]) {
            time = [averages[@"time"] doubleValue];
        }
        [route setEstimatedTime:@(time)];

        double distance = 0;
        if (averages[@"distance"] != [NSNull null]) {
            distance = [averages[@"distance"] doubleValue];
        }
        [route setTotalKm:distance];

//        int routeId = [routeData[@"id"] intValue];
//        [route setRouteId:routeId];

        [[self routes] addObject:route];
    }
}

@end
