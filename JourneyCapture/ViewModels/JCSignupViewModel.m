//
//  JCSignupViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSignupViewModel.h"
#import "JCAPIManager.h"
#import <GSKeychain/GSKeychain.h>

@implementation JCSignupViewModel
@synthesize email, password, firstName, lastName;
@synthesize isValidDetails;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    RACSignal *emailSignal = RACObserve(self, email);
    RACSignal *passwordSignal = RACObserve(self, password);
    RACSignal *firstNameSignal = RACObserve(self, firstName);
    RACSignal *lastNameSignal = RACObserve(self, lastName);

    self.isValidDetails = [RACSignal combineLatest:@[ emailSignal, passwordSignal, firstNameSignal, lastNameSignal ]
                                            reduce:^id(NSString *emailValue, NSString *passwordValue,
                                                       NSString *first, NSString *last){
                                                return @(emailValue.length > 0 && passwordValue.length > 0 &&
                                                first.length > 0 && last.length > 0);
                                            }];

    return self;
}

- (RACSignal *)signup
{
    JCAPIManager *manager = [JCAPIManager manager];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dob = [formatter stringFromDate:[NSDate date]];

    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:self.email, @"email",
                              self.password, @"password",
                              self.firstName, @"first_name",
                              self.lastName, @"last_name",
                              dob, @"dob",
                              @(1), @"gender",
                              nil];

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *signupParams = [NSDictionary dictionaryWithObject:userData forKey:@"user"];
        AFHTTPRequestOperation *op = [manager POST:@"/signup.json"
           parameters:signupParams
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  // Registered, store user token
                  NSLog(@"Register success");
                  NSLog(@"%@", responseObject);
                  NSString *userToken = responseObject[@"user_token"];
                  if (userToken) {
                      [[GSKeychain systemKeychain] setSecret:userToken forKey:@"user_token"];
                      [[GSKeychain systemKeychain] setSecret:self.email forKey:@"user_email"];
                      [subscriber sendCompleted];
                  } else if (responseObject[@"errors"]) {
                      [subscriber sendNext:responseObject[@"errors"]];
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Signin failure");
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
