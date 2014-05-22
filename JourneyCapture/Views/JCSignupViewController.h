//
//  JCSignupViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCSignupViewModel, JCSignupView;

@interface JCSignupViewController : UIViewController

@property (strong, nonatomic) JCSignupViewModel *viewModel;
@property (strong, nonatomic) JCSignupView *signupView;

- (id)initWithViewModel:(JCSignupViewModel *)signupViewModel;

@end
