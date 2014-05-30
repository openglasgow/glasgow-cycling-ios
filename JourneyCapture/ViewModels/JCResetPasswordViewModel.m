//
//  JCResetPasswordViewModel.m
//  JourneyCapture
//
//  Created by Michael Hayes on 29/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCResetPasswordViewModel.h"
#import "JCAPIManager.h"

@implementation JCResetPasswordViewModel

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
    
    self.isValidDetails = [RACSignal combineLatest:@[ self.emailValid ]
                                            reduce:^id(id eValid){
                                                return @([eValid boolValue]);
                                            }];
    
    return self;
}

-(RACSignal *)reset
{
    NSLog(@"Reset Password");
    JCAPIManager *manager = [JCAPIManager manager];
    NSDictionary *passwordData = @{
                                   @"email": _email,
                                   };
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager POST:@"/forgot_password.json"
                                       parameters:passwordData
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              // Registered, store user token
                                              NSLog(@"Password Reset sent");
                                              NSLog(@"%@", responseObject);
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"Password reset failure");
                                              NSLog(@"%@", error);
                                              if ([[operation response] statusCode] == 401) {
                                                  self.emailError = @"Incorrect email details";
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
