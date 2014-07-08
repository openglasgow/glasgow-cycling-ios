//
//  JCSigninViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSigninViewModel.h"
#import "JCAPIManager.h"
#import <GSKeychain/GSKeychain.h>

@implementation JCSigninViewModel
@synthesize email, password, emailError, passwordError,
            isValidDetails, emailValid, passwordValid;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.emailValid = [RACObserve(self, email) map:^(NSString *emailValue) {
        NSCharacterSet *emailSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
        return @(emailValue.length >= 5 &&
                    [emailValue rangeOfCharacterFromSet:emailSet].location != NSNotFound);

    }];

    self.passwordValid = [RACObserve(self, password) map:^(NSString *emailValue) {
        return @(emailValue.length >= 8);
    }];

    self.isValidDetails = [RACSignal combineLatest:@[ emailValid, passwordValid ]
                                            reduce:^id(id eValid, id pValid){
                                                return @([eValid boolValue] && [pValid boolValue]);
                                            }];
    
    return self;
}

-(RACSignal *)signin
{
    NSLog(@"Sign in");
    JCAPIManager *manager = [JCAPIManager manager];
    NSDictionary *signinParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                  CLIENT_ID, @"client_id",
                                  CLIENT_SECRET, @"client_secret",
                                  @"password", @"grant_type",
                                  email, @"email",
                                  password, @"password",
                                  nil];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager POST:@"/oauth/token"
          parameters:signinParams
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 // Registered, store user token
                 NSLog(@"Signin success");
                 NSLog(@"%@", responseObject);
                 NSString *accessToken = [responseObject objectForKey:@"access_token"];
                 NSString *refreshToken = [responseObject objectForKey:@"refresh_token"];
                 if (accessToken) {
                     [[GSKeychain systemKeychain] setSecret:accessToken forKey:@"access_token"];
                 }
                 
                 if (refreshToken) {
                     [[GSKeychain systemKeychain] setSecret:refreshToken forKey:@"refresh_token"];
                 }
                 
                 NSNumber *expiresIn = [responseObject objectForKey:@"expires_in"];
                 NSDate *expiresAt = [NSDate dateWithTimeIntervalSinceNow:expiresIn.integerValue];
                 [[NSUserDefaults standardUserDefaults] setObject:expiresAt forKey:@"expires_at"];
                 
                 if ([responseObject objectForKey:@"errors"]) {
                     [subscriber sendNext:[responseObject objectForKey:@"errors"]];
                 } else {
                     [subscriber sendCompleted];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Signin failure");
                 NSLog(@"%@", error);
                 if ([[operation response] statusCode] == 401) {
                     self.emailError = @"Incorrect login details";
                     self.passwordError = @"Incorrect login details";
                 }
                [subscriber sendError:error];
             }
         ];
        
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

@end
