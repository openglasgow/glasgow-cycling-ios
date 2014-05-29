//
//  JCResetPasswordViewModel.h
//  JourneyCapture
//
//  Created by Michael Hayes on 29/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCResetPasswordViewModel : RVMViewModel

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *emailError;

@property (nonatomic, strong) RACSignal *isValidDetails;
@property (nonatomic, strong) RACSignal *emailValid;

@end
