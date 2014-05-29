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
    
    // Email
    _emailFieldLabel = [UILabel new];
    _emailFieldLabel.text = @"Email Address";
    _emailFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_emailFieldLabel];
    
    _emailField = [JCTextField new];
    _emailField.userInteractionEnabled = YES;
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.placeholder = @"Reset Password";
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
    [_resetButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    _resetButton.layer.masksToBounds = YES;
    _resetButton.layer.cornerRadius = 4.0f;
    [self addSubview:_resetButton];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    
    int labelPadding = 3;
    int padding = 10;
    
    [_emailFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_emailFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [_emailFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:padding];
    
    [_emailField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_emailField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_emailField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailFieldLabel withOffset:labelPadding];

    [_resetButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_resetButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_resetButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailField withOffset:padding];
    
    [super layoutSubviews];
}


@end
