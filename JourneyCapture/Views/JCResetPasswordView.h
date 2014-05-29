//
//  JCResetPassword.h
//  JourneyCapture
//
//  Created by Michael Hayes on 29/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCResetPasswordViewModel, JCTextField;

@interface JCResetPasswordView : UIView

@property (strong, nonatomic) JCResetPasswordViewModel *viewModel;
@property (strong, nonatomic) UILabel *emailFieldLabel;
@property (strong, nonatomic) JCTextField *emailField;
@property (strong, nonatomic) UIButton *resetButton;

- (id)initWithViewModel:(JCResetPasswordViewModel *)resetPasswordViewModel;

@end
