//
//  JCPasswordViewModel.m
//  JourneyCapture
//
//  Created by Michael Hayes on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPasswordViewModel.h"
#import "User.h"
#import "JCAPIManager.h"

@implementation JCPasswordViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _user = [User MR_findFirst];
    [self setEmail:_user.email];
    
    self.passwordValid = [RACSignal combineLatest:@[ RACObserve(self, updatedPassword),
                                                     RACObserve(self, confirmPassword)]
                      reduce:^id(NSString *updatedPassword, NSString *confirmPassword){
                          return @(updatedPassword.length == 0 ||
                                   confirmPassword.length == 0 ||
                                  [updatedPassword isEqualToString:confirmPassword]);
                      }];
    
    return self;
  
}

- (RACSignal *)submit
{
    JCAPIManager *manager = [JCAPIManager manager];
    
    // Submit signup
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // User data
        NSDictionary *passwordData = @{
                                   @"old_password": _oldPassword,
                                   @"new_password": _updatedPassword
                                   };
        
        AFHTTPRequestOperation *op = [manager POST:@"/reset_password.json"
                                       parameters:passwordData
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              // Registered, store user token
                                              NSLog(@"Password update success");
                                              NSLog(@"%@", responseObject);
                                              [subscriber sendCompleted];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"Password failure");
                                              NSLog(@"%@", error);
                                              NSLog(@"Response: %@", [operation responseObject]);
                                              @strongify(self);
                                              if (operation.response.statusCode == 401) {
                                                  self.unauthorizedError = @"Incorrect password";
                                                  self.invalidPasswordError = @"";
                                              } else {
                                                  self.invalidPasswordError = @"New password is invalid";
                                                  self.unauthorizedError = @"";
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
