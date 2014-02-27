//
//  JCSigninViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@interface JCSigninViewModel : RVMViewModel

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@property (nonatomic, strong) RACSignal *isValidDetails;

- (RACSignal *)signin;

@end
