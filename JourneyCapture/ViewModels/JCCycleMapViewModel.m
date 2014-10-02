//
//  JCCycleMapViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCycleMapViewModel.h"
#import "JCAPIManager.h"
#import "JCCycleMapLocationViewModel.h"
#import "JCCycleMapAnnotation.h"

@implementation JCCycleMapViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (RACSignal *)load
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        JCAPIManager *manager = [JCAPIManager manager];
        AFHTTPRequestOperation *op = [manager GET:@"/poi/all.json" parameters:nil
            success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSArray *locations = responseObject[@"locations"];
              _annotations = [[NSMutableArray alloc] init];
              for (NSDictionary *location in locations) {
                  double lat = [location[@"lat"] doubleValue];
                  double lng = [location[@"long"] doubleValue];
                  NSString *type = location[@"type"];
                  
                  JCCycleMapAnnotation *annotation = [JCCycleMapAnnotation new];
                  annotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
                  if (location[@"name"] != [NSNull null]) {
                      annotation.title = location[@"name"];
                  } else {
                      annotation.title = type;
                  }
                  annotation.groupTag = type;
                  annotation.image = [UIImage imageNamed:[NSString stringWithFormat:@"map-pin-%@", type]];
                  [_annotations addObject:annotation];
              }
              
              [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Cycle map load failure");
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
