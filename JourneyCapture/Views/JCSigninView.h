//
//  JCSigninView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCSigninViewModel, JCTextField;

@interface JCSigninView : UIView
@property (strong, nonatomic) JCSigninViewModel *viewModel;
@property (strong, nonatomic) JCTextField *emailField;
@property (strong, nonatomic) JCTextField *passwordField;
@property (strong, nonatomic) UILabel *passwordFieldLabel;
@property (strong, nonatomic) UILabel *emailFieldLabel;
@property (strong, nonatomic) UIButton *signinButton;
@property (strong, nonatomic) UIButton *signupButton;

- (id)initWithViewModel:(JCSigninViewModel *)signinViewModel;
@end
