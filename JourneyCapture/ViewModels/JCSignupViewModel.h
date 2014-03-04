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
@property (nonatomic, strong) NSString *DOB;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *picture;

@property (nonatomic, strong) RACSignal *isValidDetails;

- (RACSignal *)signup;

@end
