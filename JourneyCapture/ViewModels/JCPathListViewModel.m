//
// Created by Chris Sloey on 12/05/2014.
// Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCJourneyViewModel.h"
#import "JCRouteViewModel.h"
#import "JCUserJourneyListViewModel.h"
#import "JCPathListViewModel.h"
#import "JCAPIManager.h"

@implementation JCPathListViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

-(NSDictionary *)searchParams
{
    return @{};
}

- (RACSignal *)loadItems
{
    NSLog(@"Loading user routes");
    JCAPIManager *manager = [JCAPIManager manager];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/routes.json"
                                       parameters:[self searchParams]
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *routesDict) {
                                              // Registered, store user token
                                              self.items = [NSMutableArray new];
                                              
                                              NSLog(@"User routes load success");
                                              NSLog(@"%@", routesDict);
                                              NSArray *routesResponse = routesDict[@"routes"];
                                              
                                              [self storeItems:routesResponse];
                                              
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

- (void)storeItems:(NSArray *)allItemData
{
    for (NSDictionary *data in allItemData) {
        if (data[@"id"]) {
            // Item is a route - not a collection of routes
            JCRouteViewModel *routeVM = [JCRouteViewModel new];
            routeVM.routeId = [data[@"id"] intValue];
            [self storeItem:data inViewModel:routeVM];
        } else {
            [self storeItem:data inViewModel:[JCJourneyViewModel new]];
        }
    }
}

-(void)storeItem:(NSDictionary *)itemData inViewModel:(JCPathViewModel *)pathVM
{
    // Location Names
    NSString *startName;
    if (itemData[@"start_name"] != [NSNull null]) {
        startName = itemData[@"start_name"];
    }

    NSString *endName;
    if (itemData[@"end_name"] != [NSNull null]) {
        startName = itemData[@"end_name"];
    }

    if (startName && endName) {
        [pathVM setName:[NSString stringWithFormat:@"%@ to %@", startName, endName]];
    } else if (startName) {
        [pathVM setName:[NSString stringWithFormat:@"from %@", startName]];
    } else if (endName) {
        [pathVM setName:[NSString stringWithFormat:@"to %@", endName]];
    } else {
        [pathVM setName:@"Glasgow City Route"];
    }
    
    // Locations
    if (itemData[@"start_maidenhead"] != [NSNull null]) {
        [pathVM setStartMaidenhead:itemData[@"start_maidenhead"]];
    }
    
    if (itemData[@"end_maidenhead"] != [NSNull null]) {
        [pathVM setEndMaidenhead:itemData[@"end_maidenhead"]];
    }

    // Reviews
    [pathVM setNumInstances:[itemData[@"num_instances"] intValue]];
    [pathVM setNumReviews:[itemData[@"num_reviews"] intValue]];

    // Average values
    NSDictionary *averages = itemData[@"averages"];

    double safetyRating = 0;
    if (averages[@"safety_rating"] != [NSNull null]) {
        safetyRating = [averages[@"safety_rating"] doubleValue];
    }
    [pathVM setSafetyRating:safetyRating];

    double difficultyRating = 0;
    if (averages[@"difficulty_rating"] != [NSNull null]) {
        difficultyRating = [averages[@"difficulty_rating"] doubleValue];
    }
    [pathVM setDifficultyRating:difficultyRating];

    double environmentRating = 0;
    if (averages[@"environment_rating"] != [NSNull null]) {
        environmentRating = [averages[@"environment_rating"] doubleValue];
    }
    [pathVM setSafetyRating:environmentRating];

    double averageRating = (safetyRating + difficultyRating + environmentRating) / 3.0f;
    [pathVM setSafetyRating:averageRating];

    double time = 0;
    if (averages[@"time"] != [NSNull null]) {
        time = [averages[@"time"] doubleValue];
    }
    [pathVM setTime:@(time)];

    double distanceKm = 0;
    if (averages[@"distance"] != [NSNull null]) {
        distanceKm = [averages[@"distance"] doubleValue];
    }
    double distanceMiles = distanceKm * 0.621371192;
    [pathVM setAverageMiles:@(distanceMiles)];
    
    double speedMetersPerSec = 0;
    if (averages[@"distance"] != [NSNull null]) {
        speedMetersPerSec = [averages[@"speed"] doubleValue];
    }
    double speedMph = speedMetersPerSec * 2.23693629;
    [pathVM setAveraeSpeed:@(speedMph)];

    [[self items] addObject:pathVM];
}
@end