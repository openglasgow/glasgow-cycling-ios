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
    
    _usernameValid = [RACObserve(self, username) map:^(NSString *usernameValue) {
        return @(usernameValue.length > 0);
    }];
    
    _genderValid = [RACObserve(self, gender) map:^(NSString *genderValue) {
        return @(genderValue.length > 0);
    }];
    
    _isValidDetails = [RACSignal combineLatest:@[ self.emailValid, self.usernameValid, self.genderValid ]
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
                                   @"username": _username,
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
                       _usernameError = nil;
                       if (fieldErrors[@"email"]) {
                           NSArray *emailErrors = fieldErrors[@"email"];
                           NSString *errorMessage = emailErrors[0];
                           self.emailError = [NSString stringWithFormat:@"Email %@", errorMessage];
                       }
                       
                       if (fieldErrors[@"username"]) {
                           NSArray *firstNameErrors = fieldErrors[@"username"];
                           NSString *errorMessage = firstNameErrors[0];
                           self.usernameError = [NSString stringWithFormat:@"Username %@", errorMessage];
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
    [self setUsername:_user.username];
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
