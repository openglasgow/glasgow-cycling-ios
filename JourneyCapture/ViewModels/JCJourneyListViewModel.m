//
//  JCJourneyListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCJourneyListViewModel.h"
#import "JCRouteViewModel.h"
#import "JCJourneyViewModel.h"

@implementation JCJourneyListViewModel

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

-(void)storeRoutes:(NSArray *)allJourneyData
{
    for (int i = 0; i < allJourneyData.count; i++) {
        NSDictionary *journeyData = allJourneyData[i];
        JCPathViewModel *journey = [[JCPathViewModel alloc] init];

        NSString *startName;
        if (journeyData[@"start_name"] != [NSNull null]) {
            startName = journeyData[@"start_name"];
        }

        NSString *endName;
        if (journeyData[@"end_name"] != [NSNull null]) {
            startName = journeyData[@"end_name"];
        }

        if (startName && endName) {
            [journey setName:[NSString stringWithFormat:@"%@ to %@", startName, endName]];
        } else if (startName) {
            [journey setName:[NSString stringWithFormat:@"from %@", startName]];
        } else if (endName) {
            [journey setName:[NSString stringWithFormat:@"to %@", endName]];
        } else {
            [journey setName:@"Glasgow City Route"];
        }

        [journey setNumInstances:[journeyData[@"num_routes"] intValue]];
        [journey setNumReviews:[journeyData[@"num_reviews"] intValue]];

        // Average values
        NSDictionary *averages = journeyData[@"averages"];

        double safetyRating = 0;
        if (averages[@"safety_rating"] != [NSNull null]) {
            safetyRating = [averages[@"safety_rating"] doubleValue];
        }
        [journey setSafetyRating:safetyRating];

        double difficultyRating = 0;
        if (averages[@"difficulty_rating"] != [NSNull null]) {
            difficultyRating = [averages[@"difficulty_rating"] doubleValue];
        }
        [journey setDifficultyRating:difficultyRating];

        double environmentRating = 0;
        if (averages[@"environment_rating"] != [NSNull null]) {
            environmentRating = [averages[@"environment_rating"] doubleValue];
        }
        [journey setSafetyRating:environmentRating];

        double averageRating = (safetyRating + difficultyRating + environmentRating) / 3.0f;
        [journey setSafetyRating:averageRating];

        double time = 0;
        if (averages[@"time"] != [NSNull null]) {
            time = [averages[@"time"] doubleValue];
        }
        [journey setTime:@(time)];

        double distanceKm = 0;
        if (averages[@"distance"] != [NSNull null]) {
            distanceKm = [averages[@"distance"] doubleValue];
        }
        double distanceMiles = distanceKm * 0.621371192;
        [journey setAverageMiles:@(distanceMiles)];

        [[self journeys] addObject:journey];
    }
}

@end
