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
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        self.locations = @[
                            [JCCycleMapLocationViewModel new]
                           ];
        
        [subscriber sendCompleted];
//        JCAPIManager *manager = [JCAPIManager manager];
//        AFHTTPRequestOperation *op = [manager GET:@"/stats/days.json" parameters:statsParams
//                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//
//                                              @strongify(self);
//                                              [subscriber sendCompleted];
//                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                              NSLog(@"Cycle map load failure");
//                                              NSLog(@"%@", error);
//                                              [subscriber sendError:error];
//                                          }
//                                      ];
        
        return [RACDisposable disposableWithBlock:^{
//            [op cancel];
        }];
        
    }];
}
@end
