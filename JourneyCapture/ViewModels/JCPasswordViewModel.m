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
    [self loadEmailFromUser:_user];
    
    return self;
  
}

- (RACSignal *)submit
{
    JCAPIManager *manager = [JCAPIManager manager];
    
    // Submit signup
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // User data
        NSDictionary *passwordData = @{
                                   @"old_password": _oldPassword,
                                   @"new_password": _updatedPassword,
                                   @"confirm_password": _confirmPassword
                                   };
        // TODO imageEncoded. email.
        
        AFHTTPRequestOperation *op = [manager PUT:@"/details.json"
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
                                              NSDictionary *errorData = [operation responseObject];
                                              if (errorData && errorData[@"errors"]) {
                                                  NSDictionary *fieldErrors = errorData[@"errors"];
                                                  if (fieldErrors[@"email"]) {
                                                      NSArray *emailErrors = fieldErrors[@"email"];
                                                  }
                                              }
                                              [subscriber sendError:error];
                                          }
                                      ];
        
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}


-(void)loadEmailFromUser:(User *)userModel
{
    _user = userModel;
    [self setEmail:_user.email];
}
@end
