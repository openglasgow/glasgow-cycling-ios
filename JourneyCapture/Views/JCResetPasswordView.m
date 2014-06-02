//
//  JCResetPassword.m
//  JourneyCapture
//
//  Created by Michael Hayes on 29/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCResetPasswordView.h"
#import "JCTextField.h"
#import "JCResetPasswordViewModel.h"

@implementation JCResetPasswordView

- (id)initWithViewModel:(JCResetPasswordViewModel *)resetPasswordViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _viewModel = resetPasswordViewModel;
    UIFont *labelFont = [UIFont systemFontOfSize:14];
    
    // Email
    _emailFieldLabel = [UILabel new];
    _emailFieldLabel.text = @"Email Address";
    _emailFieldLabel.font = labelFont;
    _emailFieldLabel.textColor = [UIColor jc_darkGrayColor];
    _emailFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_emailFieldLabel];
    
    _emailField = [JCTextField new];
    _emailField.userInteractionEnabled = YES;
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.placeholder = @"Registered Email";
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, email) = _emailField.rac_textSignal;
    [self addSubview:_emailField];
    [RACObserve(self, viewModel.emailError) subscribeNext:^(id x) {
        _emailField.error = _viewModel.emailError.length > 0;
    }];
    
    _resetButton = [UIButton new];
    _resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_resetButton setTintColor:[UIColor whiteColor]];
    [_resetButton setBackgroundColor:[UIColor jc_blueColor]];
    [_resetButton setTitle:@"Reset Password" forState:UIControlStateNormal];
    _resetButton.layer.masksToBounds = YES;
    _resetButton.layer.cornerRadius = 4.0f;
    [self addSubview:_resetButton];
    
    _instructionsLabel = [UILabel new];
    _instructionsLabel.text = @"Enter your email address to be sent password reset instructions";
    _instructionsLabel.numberOfLines = 2;
    _instructionsLabel.textColor = [UIColor jc_darkGrayColor];
    _instructionsLabel.textAlignment = NSTextAlignmentCenter;
    _instructionsLabel.font = [UIFont systemFontOfSize:13.0f];
    _instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_instructionsLabel];
    
    _errorLabel = [UILabel new];
    _errorLabel.text = @"This email is not registered";
    _errorLabel.textColor = [UIColor jc_redColor];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.font = [UIFont systemFontOfSize:14.0f];
    _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_errorLabel];
    
    return self;
}

- (void)setErrorHidden:(BOOL)hidden
{
    NSUInteger height;
    if (hidden) {
        height = 0;
    } else {
        height = 22;
    }
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.4
                     animations:^{
                         _errorLabelHeightConstraint.constant = height;
                         [self layoutIfNeeded];
                     }];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    int labelPadding = 3;
    int padding = 10;
    
    [_errorLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:padding];
    [_errorLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_errorLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    if (!_errorLabelHeightConstraint) {
        _errorLabelHeightConstraint = [_errorLabel autoSetDimension:ALDimensionHeight toSize:0];
    }
    
    [_emailFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_emailFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [_emailFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_errorLabel withOffset:padding];
    
    [_emailField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_emailField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_emailField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailFieldLabel withOffset:labelPadding];

    [_resetButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_resetButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_resetButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailField withOffset:padding];
    
    [_instructionsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_resetButton withOffset:padding];
    [_instructionsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_instructionsLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    
    [super layoutSubviews];
}


@end
