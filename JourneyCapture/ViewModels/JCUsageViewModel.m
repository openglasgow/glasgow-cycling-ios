//
//  JCUsageViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//
//  Loads and stores an array (periods) of usage data.
//

#import "JCUsageViewModel.h"
#import "JCAPIManager.h"

@implementation JCUsageViewModel

NSString * kStatsDistanceKey = @"distance";

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadStatsForDays:7];
    }
    return self;
}

- (RACSignal *)loadStatsForDays:(NSInteger)numDays
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *statsParams = @{@"num_days": @(numDays)};
        JCAPIManager *manager = [JCAPIManager manager];
        AFHTTPRequestOperation *op = [manager GET:@"/stats/days.json" parameters:statsParams
            success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                // Loaded user details
                NSLog(@"Stays load success: %ld days", (long)numDays);
                NSLog(@"%@", responseObject);
                
                @strongify(self);
                self.periods = responseObject[@"days"];
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Stats load failure");
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
