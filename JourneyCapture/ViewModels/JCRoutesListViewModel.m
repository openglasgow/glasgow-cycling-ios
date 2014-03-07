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
                                                  [route setSafetyRating:routeData[@"safety_rating"]];
                                                  [route setDifficultyRating:routeData[@"difficulty_rating"]];
                                                  [route setEnvironmentRating:routeData[@"environment_rating"]];
                                                  [route setEstimatedTime:routeData[@"estimated_time"]];
                                                  [route setDistanceMetres:routeData[@"total_distance"]];
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
