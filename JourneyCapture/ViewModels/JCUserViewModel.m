//
//  JCUserViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserViewModel.h"
#import "JCAPIManager.h"
#import <GSKeychain/GSKeychain.h>

@implementation JCUserViewModel
@synthesize firstName, lastName, favouriteRouteName, routesThisMonth, secondsThisMonth, kmThisMonth;
- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

-(RACSignal *)loadDetails
{
    NSLog(@"Loading user");
    JCAPIManager *manager = [JCAPIManager manager];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/details.json"
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                              // Registered, store user token
                                              NSLog(@"User load success");
                                              NSLog(@"%@", responseObject);
                                              [self setFirstName:responseObject[@"first_name"]];
                                              [self setLastName:responseObject[@"last_name"]];

                                              NSDictionary *stats = responseObject[@"month"];
                                              [self setFavouriteRouteName:stats[@"route"]];
                                              [self setSecondsThisMonth:stats[@"seconds"]];
                                              [self setKmThisMonth:stats[@"km"]];
                                              [self setRoutesThisMonth:stats[@"total"]];

                                              NSString *base64Pic = responseObject[@"profile_pic"];
                                              if (base64Pic) {
                                                  NSData *picData = [[NSData alloc] initWithBase64EncodedString:base64Pic options:0];
                                                  UIImage *decodedProfilePic = [UIImage imageWithData:picData];
                                                  [self setProfilePic:decodedProfilePic];
                                              } else {
                                                  [self setProfilePic:[UIImage imageNamed:@"default_profile_pic"]];
                                              }
                                              [subscriber sendCompleted];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              if ([operation.response statusCode] == 401) {
                                                  // Unauthorized
                                                  [[GSKeychain systemKeychain] removeAllSecrets];
                                              }
                                              NSLog(@"User load failure");
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
