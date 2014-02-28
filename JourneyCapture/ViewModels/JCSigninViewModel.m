//
//  JCSigninViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSigninViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import <GSKeychain/GSKeychain.h>

@implementation JCSigninViewModel
@synthesize email, password;
@synthesize isValidDetails;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    RACSignal *emailSignal = RACObserve(self, email);
    RACSignal *passwordSignal = RACObserve(self, password);
    self.isValidDetails = [RACSignal combineLatest:@[ emailSignal, passwordSignal ]
                                            reduce:^id(NSString *emailValue, NSString *passwordValue){
                                                return @(emailValue.length > 0 && passwordValue.length > 0);
                                            }];
    
    return self;
}

-(RACSignal *)signin
{
    NSLog(@"Sign in");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *signinParams = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email",
                                  password, @"password",
                                  nil];
    NSDictionary *userParams = [NSDictionary dictionaryWithObject:signinParams forKey:@"user"];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"http://188.226.184.33/signin.json"
          parameters:userParams
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 // Registered, store user token
                 NSLog(@"Signin success");
                 NSLog(@"%@", responseObject);
                 NSString *userToken = [responseObject objectForKey:@"user_token"];
                 if (userToken) {
                     [[GSKeychain systemKeychain] setSecret:userToken forKey:@"user_token"];
                     [[GSKeychain systemKeychain] setSecret:email forKey:@"user_email"];
                     [subscriber sendCompleted];
                 } else if ([responseObject objectForKey:@"errors"]) {
                     [subscriber sendNext:[responseObject objectForKey:@"errors"]];
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
