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

- (id)initWithViewModel:(JCSigninViewModel *)signinViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _viewModel = signinViewModel;

    // Email
    _emailField = [JCTextField new];
    _emailField.userInteractionEnabled = YES;
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.placeholder = @"Your Email";
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, email) = _emailField.rac_textSignal;
    [self addSubview:_emailField];
    RACChannelTo(_viewModel, emailError) = RACChannelTo(_emailField, error);

    // Password
    _passwordField = [JCTextField new];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"Your Password";
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, password) = _passwordField.rac_textSignal;
    [self addSubview:_passwordField];
    RACChannelTo(_viewModel, passwordError) = RACChannelTo(_passwordField, error);

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    int padding = 15;

    [_emailField autoRemoveConstraintsAffectingView];
    [_emailField autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(padding, padding, padding, padding)
                                          excludingEdge:ALEdgeBottom];
    [_emailField layoutError];

    [_passwordField autoRemoveConstraintsAffectingView];
    [_passwordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_passwordField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_passwordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailField withOffset:padding];
    [_passwordField layoutError];

    [super layoutSubviews];
}

@end
