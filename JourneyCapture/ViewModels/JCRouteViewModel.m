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

@end
