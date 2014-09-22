//
//  JCSettingsViewModel.h
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
@class User;

@interface JCSettingsViewModel : RVMViewModel

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) UIImage *profilePic;

@property (nonatomic, strong) NSString *emailError;
@property (nonatomic, strong) NSString *usernameError;

@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) RACSignal *isValidDetails;
@property (nonatomic, strong) RACSignal *emailValid;
@property (nonatomic, strong) RACSignal *usernameValid;
@property (nonatomic, strong) RACSignal *genderValid;

@property (strong, nonatomic) User *user;

- (RACSignal *)submit;

@end
