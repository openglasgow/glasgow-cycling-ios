//
//  JCPasswordViewModel.h
//  JourneyCapture
//
//  Created by Michael Hayes on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
@class User;

@interface JCPasswordViewModel : RVMViewModel

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *newPassword;
@property (nonatomic, strong) NSString *confirmPassword;

@property (strong, nonatomic) User *user;

@end
