//
//  JCRouteManager.m
//  JourneyCapture
//
//  Created by Chris Sloey on 15/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteManager.h"
#import "JCAPIManager.h"
#import "Route.h"
#import "RoutePoint.h"

@implementation JCRouteManager

- (void)deleteIncompleteRoutes
{
    NSPredicate *incompletePredicate = [NSPredicate predicateWithFormat:@"completed = %@", @NO];
    NSArray *incompleteRoutes = [Route MR_findAllWithPredicate:incompletePredicate];
    if (incompleteRoutes.count > 0) {
        NSLog(@"Deleting %lu incomplete route(s)", incompleteRoutes.count);
        for (Route *incomplete in incompleteRoutes) {
            [incomplete MR_deleteEntity];
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"Deleted incomplete routes");
        }];
    }
}

- (void)uploadCompletedRoutes
{
    NSPredicate *completePredicate = [NSPredicate predicateWithFormat:@"completed = %@", @YES];
    NSArray *completeRoutes = [Route MR_findAllWithPredicate:completePredicate];
    if (completeRoutes.count > 0) {
        NSLog(@"Uploading %lu completed routes", completeRoutes.count);
        for (Route *completeRoute in completeRoutes) {
            [self uploadRoute:completeRoute];
        }
    }
}

- (RACSignal *)uploadRoute:(Route *)route
{
    NSLog(@"Uploading user route");
    JCAPIManager *manager = [JCAPIManager manager];
    
    NSMutableArray *pointsData = [[NSMutableArray alloc] init];
    for (RoutePoint *point in route.points) {
        NSMutableDictionary *pointData = [@{
                                            @"lat": point.lat,
                                            @"long": point.lng,
                                            @"kph": point.kph,
                                            @"altitude": point.altitude,
                                            @"time": @([point.time timeIntervalSince1970]),
                                            @"vertical_accuracy": point.verticalAccuracy,
                                            @"horizontal_accuracy": point.horizontalAccuracy,
                                            @"course": point.course
                                            } mutableCopy];
        
        if (point.streetName) {
            pointData[@"street_name"] = point.streetName;
        }
        
        [pointsData addObject:pointData];
    }
    
    NSDictionary *routeData = @{ @"points" : pointsData };
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager POST:@"/routes.json"
                                        parameters:routeData
                                           success:^(AFHTTPRequestOperation *operation, NSDictionary *routeResponse) {
                                               // Route stored on server
                                               NSLog(@"User route stored successfully");
                                               NSLog(@"%@", routeResponse);
                                               
                                               // Delete route model
                                               [route MR_deleteEntity];
                                               [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                                                   NSLog(@"Deleted submitted route");
                                               }];
                                               
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

#pragma mark - Singleton Methods

+ (JCRouteManager *)sharedManager
{
    static dispatch_once_t pred;
    static JCRouteManager *_sharedManager = nil;
    
    dispatch_once(&pred, ^{
        _sharedManager = [self new];
    });
    return _sharedManager;
}
@end
