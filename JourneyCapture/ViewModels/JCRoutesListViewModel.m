//
//  JCRoutesListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRoutesListViewModel.h"
#import "JCRouteViewModel.h"
#import "JCAPIManager.h"

@implementation JCRoutesListViewModel
@synthesize routes, title;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

-(RACSignal *)loadUserRoutes
{
    NSLog(@"Loading user routes");
    JCAPIManager *manager = [JCAPIManager manager];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/routes/user_summaries/1000/1.json"
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *routesDict) {
                                              // Registered, store user token
                                              self.routes = [[NSMutableArray alloc] init];

                                              NSLog(@"User routes load success");
                                              NSLog(@"%@", routesDict);
                                              NSArray *routesResponse = routesDict[@"routes"];

                                              for (int i = 0; i < routesResponse.count; i++) {
                                                  NSDictionary *routeData = routesResponse[i][@"details"];
                                                  JCRouteViewModel *route = [[JCRouteViewModel alloc] init];
                                                  [route setName:routeData[@"name"]];

                                                  double safetyRating = [routeData[@"safety_rating"] doubleValue];
                                                  [route setSafetyRating:safetyRating];

                                                  double difficultyRating = [routeData[@"difficulty_rating"] doubleValue];
                                                  [route setDifficultyRating:difficultyRating];

                                                  double environmentRating = [routeData[@"environment_rating"] doubleValue];
                                                  [route setEnvironmentRating:environmentRating];
                                                  [route setEstimatedTime:routeData[@"estimated_time"]];

                                                  double distance = [routeData[@"total_distance"] doubleValue];
                                                  [route setTotalKm:distance];

                                                  int routeId = [routeData[@"id"] intValue];
                                                  [route setRouteId:routeId];

                                                  [route setRouteImage:[UIImage imageNamed:@"science-centre"]];
                                                  [[self routes] addObject:route];
                                              }

                                              [subscriber sendCompleted];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"User routes load failure");
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
