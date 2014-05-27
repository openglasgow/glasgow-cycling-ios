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

@implementation JCSettingsViewModel
@synthesize email, firstName, lastName, gender, genders, profilePicture,
emailValid, firstNameValid, lastNameValid, genderValid,
emailError, isValidDetails;


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
    
    self.firstNameValid = [RACObserve(self, gender) map:^(NSString *firstNameValue) {
        return @(firstNameValue.length > 0);
    }];
    
    self.lastNameValid = [RACObserve(self, gender) map:^(NSString *lastNameValue) {
        return @(lastNameValue.length > 0);
    }];
    
    self.genderValid = [RACObserve(self, gender) map:^(NSString *genderValue) {
        return @(genderValue.length > 0);
    }];
    
    
    self.isValidDetails = [RACSignal combineLatest:@[ self.emailValid, self.firstNameValid, self.lastNameValid, self.genderValid ]
                                            reduce:^id(id eValid, id pValid, id fValid, id lValid, id dValid, id gValid){
                                                return @([eValid boolValue] && [pValid boolValue] && [fValid boolValue]
                                                && [lValid boolValue] && [dValid boolValue] && [gValid boolValue]);
                                            }];
    
    return self;
}

- (RACSignal *)submit
{
    JCAPIManager *manager = [JCAPIManager manager];
    
    // Profile pic
    NSData *imageData = [self.profilePicture compressToSize:250];
    NSString *imageEncoded = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // Submit signup
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // User data
        @strongify(self);
        NSDictionary *userData = @{
                                   @"first_name": self.firstName,
                                   @"last_name": self.lastName,
                                   @"gender": self.gender
                                   };
        // TODO imageEncoded. email.

        AFHTTPRequestOperation *op = [manager PUT:@"/details.json"
                                        parameters:userData
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               // Registered, store user token
                                               NSLog(@"Settings update success");
                                               NSLog(@"%@", responseObject);
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
