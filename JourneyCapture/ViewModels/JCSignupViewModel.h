//
//  JCSignupViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCSignupViewModel : RVMViewModel

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *dob;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) UIImage *profilePicture;

@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) RACSignal *isValidDetails;
@property (nonatomic, strong) RACSignal *emailValid;
@property (nonatomic, strong) RACSignal *passwordValid;
@property (nonatomic, strong) RACSignal *firstNameValid;
@property (nonatomic, strong) RACSignal *lastNameValid;
@property (nonatomic, strong) RACSignal *dobValid;
@property (nonatomic, strong) RACSignal *genderValid;

- (RACSignal *)signup;

@end
