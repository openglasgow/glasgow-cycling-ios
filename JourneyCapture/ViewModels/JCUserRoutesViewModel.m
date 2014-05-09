//
//  JCUserRoutesViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 01/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserRoutesViewModel.h"
#import "JCAPIManager.h"

@implementation JCUserRoutesViewModel
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    self.title = @"My Routes";
    
    return self;
}

#pragma mark - JCRoutesListViewModel

-(RACSignal *)loadRoutes
{
    NSLog(@"Loading user routes");
    JCAPIManager *manager = [JCAPIManager manager];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/routes/user_summaries/1000/1.json"
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *routesDict) {
                                              // Registered, store user token
                                              self.journeys = [[NSMutableArray alloc] init];
                                              
                                              NSLog(@"User routes load success");
                                              NSLog(@"%@", routesDict);
                                              NSArray *routesResponse = routesDict[@"routes"];
                                              
                                              [self storeRoutes:routesResponse];
                                              
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
