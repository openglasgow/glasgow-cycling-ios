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

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _genders = @[@"Undisclosed", @"Male", @"Female"];
    
    // Possible birth years
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy"];
    NSUInteger currentYear  = [[formatter stringFromDate:[NSDate date]] intValue];
    NSMutableArray *years = [NSMutableArray new];
    for (int i = 1900; i <= currentYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _birthYears = [years copy];
    
    // Validations
    _emailValid = [RACObserve(self, email) map:^(NSString *emailValue) {
        NSCharacterSet *emailSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
        return @(emailValue.length >= 5 &&
        [emailValue rangeOfCharacterFromSet:emailSet].location != NSNotFound);
    }];

    _passwordValid = [RACObserve(self, password) map:^(NSString *emailValue) {
        return @(emailValue.length >= 8);
    }];

    _firstNameValid = [RACObserve(self, gender) map:^(NSString *firstNameValue) {
        return @(firstNameValue.length > 0);
    }];

    _lastNameValid = [RACObserve(self, gender) map:^(NSString *lastNameValue) {
        return @(lastNameValue.length > 0);
    }];

    _genderValid = [RACObserve(self, gender) map:^(NSString *genderValue) {
        return @(genderValue.length > 0);
    }];

    _yobValid = [RACObserve(self, yearOfBirth) map:^(NSNumber *year) {
        return @([year intValue] > 1900);
    }];

    _isValidDetails = [RACSignal combineLatest:@[ _emailValid, _passwordValid, _firstNameValid, _lastNameValid,
                                                      _yobValid, _genderValid ]
                                            reduce:^id(id eValid, id pValid, id fValid, id lValid, id dValid, id gValid){
                                                return @([eValid boolValue] && [pValid boolValue] && [fValid boolValue]
                                                    && [lValid boolValue] && [dValid boolValue] && [gValid boolValue]);
                                            }];

    return self;
}

- (RACSignal *)signup
{
    JCAPIManager *manager = [JCAPIManager manager];

    // User data
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:_email, @"email",
                              _password, @"password",
                              _username, @"username",
                              @(_yearOfBirth), @"year_of_birth",
                              _gender.lowercaseString, @"gender",
                              nil];
    
    // Profile pic
    if (_profilePicture) {
        NSData *imageData = [_profilePicture compressToSize:250];
        NSString *compressedJpegImage = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *base64ImageString = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", compressedJpegImage];
        userData[@"profile_picture"] = base64ImageString;
    }

    // Submit signup
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *signupParams = [NSDictionary dictionaryWithObject:userData forKey:@"user"];
        AFHTTPRequestOperation *op = [manager POST:@"/signup.json"
           parameters:signupParams
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  // Registered, store user token
                  NSLog(@"Register success");
                  NSLog(@"%@", responseObject);
                  NSString *accessToken = responseObject[@"access_token"];
                  if (accessToken) {
                      [[GSKeychain systemKeychain] setSecret:accessToken forKey:@"access_token"];
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
                          NSArray *emailErrors = fieldErrors[@"email"];
                          NSString *errorMessage = emailErrors[0];
                          self.emailError = [NSString stringWithFormat:@"Email %@", errorMessage];
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
