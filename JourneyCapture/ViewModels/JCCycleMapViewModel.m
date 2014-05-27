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
              _locations = [[NSMutableArray alloc] init];
              for (NSDictionary *location in locations) {
                  double lat = [location[@"lat"] doubleValue];
                  double lng = [location[@"long"] doubleValue];
                  NSString *type = location[@"type"];
                  
                  JCCycleMapLocationViewModel *locationVM = [[JCCycleMapLocationViewModel alloc] init];
                  locationVM.coordinate = CLLocationCoordinate2DMake(lat, lng);
                  if (location[@"name"] != [NSNull null]) {
                      locationVM.name = location[@"name"];
                  } else {
                      locationVM.name = type;
                  }
                  locationVM.image = [UIImage imageNamed:[NSString stringWithFormat:@"map-pin-%@", type]];
                  [_locations addObject:locationVM];
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
