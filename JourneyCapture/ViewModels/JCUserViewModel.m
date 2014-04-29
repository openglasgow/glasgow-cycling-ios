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
- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _menuItems = @[@"My Routes", @"Nearby Routes", @"Glasgow Cycling Map", @"Something Else"];
    _menuItemImages = @[
                        [UIImage imageNamed:@"my-routes-icon"],
                        [UIImage imageNamed:@"nearby-routes-icon"],
                        [UIImage imageNamed:@"cycling-map-icon"],
                        [UIImage imageNamed:@"nearby-routes-icon"]
//                        [UIImage imageNamed:@""]
                        ];
    return self;
}

-(RACSignal *)fullNameSignal
{
    RACSignal *firstNameSignal = RACObserve(self, firstName);
    RACSignal *lastNameSignal = RACObserve(self, lastName);
    return [[RACSignal combineLatest:@[firstNameSignal, lastNameSignal]] reduceEach:^id{
        return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
    }];
}

-(RACSignal *)loadDetails
{
    NSLog(@"Loading user");
    JCAPIManager *manager = [JCAPIManager manager];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/details.json"
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                              // Loaded user details
                                              NSLog(@"User load success");
                                              NSLog(@"%@", responseObject);
                                              [self setFirstName:responseObject[@"first_name"]];
                                              [self setLastName:responseObject[@"last_name"]];

                                              NSDictionary *stats = responseObject[@"month"];
                                              [self setSecondsThisMonth:stats[@"seconds"]];
                                              [self setKmThisMonth:stats[@"km"]];
                                              [self setRoutesThisMonth:stats[@"total"]];

                                              NSString *base64Pic = responseObject[@"profile_pic"];
                                              if (base64Pic) {
                                                  NSData *picData = [[NSData alloc] initWithBase64EncodedString:base64Pic options:0];
                                                  UIImage *decodedProfilePic = [UIImage imageWithData:picData];
                                                  [self setProfilePic:decodedProfilePic];
                                              } else {
                                                  [self setProfilePic:[UIImage imageNamed:@"profile-pic"]];
                                              }
                                              [subscriber sendCompleted];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
