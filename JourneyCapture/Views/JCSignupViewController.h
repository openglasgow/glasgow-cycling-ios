//
//  JCSignupViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
#import <FDTake/FDTakeController.h>

@class JCSignupViewModel, JCSignupView;

@interface JCSignupViewController : UIViewController <FDTakeDelegate>

@property (strong, nonatomic) JCSignupViewModel *viewModel;
@property (strong, nonatomic) JCSignupView *signupView;
@property (strong, nonatomic) FDTakeController *takeController;

- (id)initWithViewModel:(JCSignupViewModel *)signupViewModel;

@end
