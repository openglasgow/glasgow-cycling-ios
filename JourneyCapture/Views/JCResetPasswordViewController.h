//
//  JCResetPasswordViewController.h
//  JourneyCapture
//
//  Created by Michael Hayes on 29/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCResetPasswordViewModel, JCResetPasswordView;

@interface JCResetPasswordViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) JCResetPasswordViewModel *viewModel;
@property (strong, nonatomic) JCResetPasswordView *resetView;

- (id)initWithViewModel:(JCResetPasswordViewModel *)resetPasswordViewModel;
- (void)resetPassword;

@end
