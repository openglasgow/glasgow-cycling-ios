//
//  JCSigninView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSigninView.h"
#import "JCSigninViewModel.h"
#import "JCTextField.h"

@implementation JCSigninView

- (id)initWithFrame:(CGRect)frame viewModel:(JCSigninViewModel *)signinViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _viewModel = signinViewModel;
    UIFont *labelFont = [UIFont systemFontOfSize:14];
    
    // Content scroll view
    _contentView = [UIScrollView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: _contentView];
    
    // Blue-backed top area
    _profileBackgroundView = [UIView new];
    [_profileBackgroundView setBackgroundColor:[UIColor jc_blueColor]];
    _profileBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_profileBackgroundView];
    
    _loadingView = [JCLoadingView new];
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    _loadingView.infoLabel.text = @"Making Glasgow a Cycling City";
    [_profileBackgroundView addSubview:_loadingView];
    
    // Email
    _emailFieldLabel = [UILabel new];
    _emailFieldLabel.text = @"Email Address";
    _emailFieldLabel.font = labelFont;
    _emailFieldLabel.textColor = [UIColor jc_darkGrayColor];
    _emailFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_emailFieldLabel];

    _emailField = [JCTextField new];
    _emailField.userInteractionEnabled = YES;
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.placeholder = @"Your Email";
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, email) = _emailField.rac_textSignal;
    [_contentView addSubview:_emailField];
    [RACObserve(self, viewModel.emailError) subscribeNext:^(id x) {
        _emailField.error = _viewModel.emailError.length > 0;
    }];

    // Password
    _passwordFieldLabel = [UILabel new];
    _passwordFieldLabel.text = @"Password";
    _passwordFieldLabel.font = labelFont;
    _passwordFieldLabel.textColor = [UIColor jc_darkGrayColor];
    _passwordFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_passwordFieldLabel];
    
    _passwordField = [JCTextField new];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"Your Password";
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, password) = _passwordField.rac_textSignal;
    [_contentView addSubview:_passwordField];
    [RACObserve(self, viewModel.passwordError) subscribeNext:^(id x) {
        _passwordField.error = _viewModel.passwordError.length > 0;
    }];
    
    _signinButton = [UIButton new];
    _signinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_signinButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [_signinButton setBackgroundColor:[UIColor jc_buttonGreenColor]];
    [_signupButton setTintColor:[UIColor whiteColor]];
    _signinButton.layer.masksToBounds = YES;
    _signinButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_signinButton];
    
    _signupButton = [UIButton new];
    _signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_signupButton setTintColor:[UIColor whiteColor]];
    [_signupButton setBackgroundColor:[UIColor jc_blueColor]];
    [_signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    _signupButton.layer.masksToBounds = YES;
    _signupButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_signupButton];
    
    _resetButton = [UIButton new];
    _resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_resetButton setTitleColor:[UIColor jc_lightBlueColor] forState:UIControlStateNormal];
    [_resetButton setTitle:@"Reset Password" forState:UIControlStateNormal];
    _resetButton.layer.masksToBounds = YES;
    [_contentView addSubview:_resetButton];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_contentView autoRemoveConstraintsAffectingView];
    [_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    int padding = 15;
    int labelPadding = 1;
    
    [_profileBackgroundView autoSetDimension:ALDimensionWidth toSize:self.frame.size.width];
    [_profileBackgroundView autoSetDimension:ALDimensionHeight toSize:180.0f];
    [_profileBackgroundView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:0];
    [_profileBackgroundView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:0];
    [_profileBackgroundView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView withOffset:0];
    [_profileBackgroundView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_emailFieldLabel withOffset:-padding];
    
    [_loadingView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_profileBackgroundView withOffset:125];
    [_loadingView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_emailFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_emailFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:padding];
    [_emailFieldLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_emailField withOffset:-labelPadding];

    [_emailField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_emailField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_emailField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_passwordFieldLabel withOffset:-padding];

    [_passwordFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_passwordFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_passwordFieldLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_passwordField withOffset:-labelPadding];

    [_passwordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_passwordField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_passwordField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_signinButton withOffset:-padding];

    [_signinButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_signinButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_signinButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_signupButton withOffset:-padding];
    
    [_signupButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_signupButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_signupButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_resetButton withOffset:-padding];
    
    [_resetButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_resetButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_resetButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_contentView withOffset:-(padding*2)];
    
    [super layoutSubviews];
}

@end
