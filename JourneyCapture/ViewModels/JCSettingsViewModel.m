//
//  JCSettingsViewModel.m
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSettingsViewModel.h"
#import "JCAPIManager.h"
#import <GSKeychain/GSKeychain.h>
#import "UIImage+Compression.h"
#import "User.h"

@implementation JCSettingsViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _user = [User MR_findFirst];
    [self loadFromUser:_user];
    
    _genders = @[@"Undisclosed", @"Male", @"Female"];
    
    _emailValid = [RACObserve(self, email) map:^(NSString *emailValue) {
        NSCharacterSet *emailSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
        return @(emailValue.length >= 5 &&
        [emailValue rangeOfCharacterFromSet:emailSet].location != NSNotFound);
    }];
    
    _firstNameValid = [RACObserve(self, firstName) map:^(NSString *firstNameValue) {
        return @(firstNameValue.length > 0);
    }];
    
    _lastNameValid = [RACObserve(self, lastName) map:^(NSString *lastNameValue) {
        return @(lastNameValue.length > 0);
    }];
    
    _genderValid = [RACObserve(self, gender) map:^(NSString *genderValue) {
        return @(genderValue.length > 0);
    }];
    
    _isValidDetails = [RACSignal combineLatest:@[ self.emailValid, self.firstNameValid, self.lastNameValid, self.genderValid ]
                                            reduce:^id(id eValid, id fValid, id lValid, id gValid){
                                                return @([eValid boolValue] && [fValid boolValue]
                                                && [lValid boolValue] && [gValid boolValue]);
                                            }];
    
    return self;
}

- (RACSignal *)submit
{
    JCAPIManager *manager = [JCAPIManager manager];
    
    // Profile pic
    NSData *imageData = [_profilePic compressToSize:250];
    NSString *compressedJpegImage = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *base64ImageString = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", compressedJpegImage];
    
    // Submit signup
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // User data
        NSDictionary *userData = @{
                                   @"first_name": _firstName,
                                   @"last_name": _lastName,
                                   @"gender": _gender,
                                   @"profile_pic": base64ImageString
                                   };
        // TODO email.

        AFHTTPRequestOperation *op = [manager PUT:@"/details.json"
                                        parameters:userData
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               // Registered, store user token
                                               NSLog(@"Settings update success");
                                               NSLog(@"%@", responseObject);
                                               [subscriber sendCompleted];
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               NSLog(@"Signin failure");
                                               NSLog(@"%@", error);
                                               NSLog(@"Response: %@", [operation responseObject]);
                                               NSDictionary *errorData = [operation responseObject];
                                               if (errorData && errorData[@"errors"]) {
                                                   NSDictionary *fieldErrors = errorData[@"errors"];
                                                   _emailError = nil;
                                                   _firstNameError = nil;
                                                   _lastNameError = nil;
                                                   if (fieldErrors[@"email"]) {
                                                       NSArray *emailErrors = fieldErrors[@"email"];
                                                       NSString *errorMessage = emailErrors[0];
                                                       self.emailError = [NSString stringWithFormat:@"Email %@", errorMessage];
                                                   }
                                                   
                                                   if (fieldErrors[@"first_name"]) {
                                                       NSArray *firstNameErrors = fieldErrors[@"first_name"];
                                                       NSString *errorMessage = firstNameErrors[0];
                                                       self.firstNameError = [NSString stringWithFormat:@"First name %@", errorMessage];
                                                   }
                                                   
                                                   if (fieldErrors[@"last_name"]) {
                                                       NSArray *lastNameErrors = fieldErrors[@"last_name"];
                                                       NSString *errorMessage = lastNameErrors[0];
                                                       self.lastNameError = [NSString stringWithFormat:@"Last name %@", errorMessage];
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


-(void)loadFromUser:(User *)userModel
{
    _user = userModel;
    [self setFirstName:_user.firstName];
    [self setLastName:_user.lastName];
    [self setGender:_user.gender];
    [self setEmail:_user.email];
    NSData *picData = _user.image;
    if (picData) {
        [self setProfilePic:[UIImage imageWithData:picData]];
    } else {
       [self setProfilePic:[UIImage imageNamed:@"profile-pic"]];
    }
}

@end
