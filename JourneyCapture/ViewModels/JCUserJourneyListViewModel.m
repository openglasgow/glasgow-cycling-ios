//
//  JCUserJourneyListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 01/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserJourneyListViewModel.h"
#import "JCAPIManager.h"
#import "JCRouteViewModel.h"
#import "JCJourneyViewModel.h"
#import "JCPathListViewModel.h"

@implementation JCUserJourneyListViewModel
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    self.title = @"My Routes";
    
    return self;
}

#pragma mark - JCJourneyListViewModel

-(RACSignal *)loadItems
{
    NSLog(@"Loading user routes");
    JCAPIManager *manager = [JCAPIManager manager];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/routes/user_summaries/1000/1.json"
                                       parameters:nil
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

@end
