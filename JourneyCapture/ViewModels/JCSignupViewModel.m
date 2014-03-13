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
#import "UIImage+Compression.h"

@implementation JCSignupViewModel
@synthesize email, password, firstName, lastName, dob, gender, genders, profilePicture,
            emailValid, passwordValid, firstNameValid, lastNameValid, genderValid, dobValid,
            emailError, passwordError,
            isValidDetails;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.genders = @[@"Undisclosed", @"Male", @"Female"];

    self.emailValid = [RACObserve(self, email) map:^(NSString *emailValue) {
        NSCharacterSet *emailSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
        return @(emailValue.length >= 5 &&
        [emailValue rangeOfCharacterFromSet:emailSet].location != NSNotFound);

    }];

    self.passwordValid = [RACObserve(self, password) map:^(NSString *emailValue) {
        return @(emailValue.length >= 8);
    }];

    self.firstNameValid = [RACObserve(self, gender) map:^(NSString *firstNameValue) {
        return @(firstNameValue.length > 0);
    }];

    self.lastNameValid = [RACObserve(self, gender) map:^(NSString *lastNameValue) {
        return @(lastNameValue.length > 0);
    }];

    self.genderValid = [RACObserve(self, gender) map:^(NSString *genderValue) {
        return @(genderValue.length > 0);
    }];

    self.dobValid = [RACObserve(self, dob) map:^(NSString *dobValue) {
        return @(dobValue != nil);
    }];

    self.isValidDetails = [RACSignal combineLatest:@[ self.emailValid, self.passwordValid, self.firstNameValid, self.lastNameValid,
                                                      self.dobValid, self.genderValid ]
                                            reduce:^id(id eValid, id pValid, id fValid, id lValid, id dValid, id gValid){
                                                return @([eValid boolValue] && [pValid boolValue] && [fValid boolValue]
                                                    && [lValid boolValue] && [dValid boolValue] && [gValid boolValue]);
                                            }];

    return self;
}

- (RACSignal *)signup
{
    JCAPIManager *manager = [JCAPIManager manager];

    // DOB
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDob = [formatter stringFromDate:self.dob];

    // Profile pic
    NSData *imageData = [self.profilePicture compressToSize:250];
    NSString *imageEncoded = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    // User data
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:self.email, @"email",
                              self.password, @"password",
                              self.firstName, @"first_name",
                              self.lastName, @"last_name",
                              formattedDob, @"dob",
                              self.gender, @"gender",
                              imageEncoded, @"profile_picture",
                              nil];

    // Submit signup
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
                  NSLog(@"Response: %@", [operation responseObject]);
                  NSDictionary *errorData = [operation responseObject];
                  if (errorData && errorData[@"errors"]) {
                      NSDictionary *fieldErrors = errorData[@"errors"];
                      if (fieldErrors[@"email"]) {
                          self.emailError = [NSString stringWithFormat:@"Email %@", fieldErrors[@"email"][0]];
                      } else {
                          self.emailError = nil;
                      }

                      if (fieldErrors[@"password"]) {
                          self.passwordError = [NSString stringWithFormat:@"Password %@", fieldErrors[@"password"][0]];
                      } else {
                          self.passwordError = nil;
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

@end
