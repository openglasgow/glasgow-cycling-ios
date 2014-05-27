//
//  JCPasswordView.m
//  JourneyCapture
//
//  Created by Michael Hayes on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPasswordView.h"

@implementation JCPasswordView

- (id)initWithViewModel:(JCPasswordViewModel *)passwordViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _viewModel = passwordViewModel;
    
    UIFont *labelFont = [UIFont systemFontOfSize:14];
    
    // Content scroll view
    _contentView = [UIScrollView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: _contentView];
    
    // old Password
    _oldPasswordLabel = [UILabel new];
    _oldPasswordLabel.text = @"Old Password";
    _oldPasswordLabel.font = labelFont;
    _oldPasswordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_oldPasswordLabel];
    
    _oldPasswordField = [JCTextField new];
    _oldPasswordField.userInteractionEnabled = YES;
    _oldPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    _oldPasswordField.font = labelFont;
    _oldPasswordField.keyboardType = UIKeyboardTypeEmailAddress;
    _oldPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _oldPasswordField.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_emailField];
    [[_emailField.rac_textSignal skip:1] subscribeNext:^(id x) {
        _viewModel._oldPassword = _oldPasswordField.text;
    }];
    
    // New Password
    _newPasswordLabel = [UILabel new];
    _newPasswordLabel.text = @"New Password";
    _newPasswordLabel.font = labelFont;
    _newPasswordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_newPasswordLabel];
    
    _newPasswordField = [JCTextField new];
    _newPasswordField.userInteractionEnabled = YES;
    _newPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    _newPasswordField.font = labelFont;
    _newPasswordField.keyboardType = UIKeyboardTypeEmailAddress;
    _newPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _newPasswordField.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_emailField];
    [[_emailField.rac_textSignal skip:1] subscribeNext:^(id x) {
        _viewModel._newPasswordField = _newPasswordField.text;
    }];
    
    // Confirm Password
    _confirmPasswordLabel = [UILabel new];
    _confirmPasswordLabel.text = @"Confirm New Password";
    _confirmPasswordLabel.font = labelFont;
    _confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_confirmPasswordLabel];
    
    _confirmPasswordField = [JCTextField new];
    _confirmPasswordField.userInteractionEnabled = YES;
    _confirmPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    _confirmPasswordField.font = labelFont;
    _confirmPasswordField.keyboardType = UIKeyboardTypeEmailAddress;
    _confirmPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _confirmPasswordField.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_emailField];
    [[_emailField.rac_textSignal skip:1] subscribeNext:^(id x) {
        _viewModel._confirmPasswordField = _confirmPasswordField.text;
    }];
    
    _submitButton = [UIButton new];
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_submitButton setTintColor:[UIColor whiteColor]];
    [_submitButton setBackgroundColor:[UIColor jc_buttonGreenColor]];
    [_submitButton setTitle:@"Submit New Password" forState:UIControlStateNormal];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_submitButton];
    
    _resetButton = [UIButton new];
    _resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_resetButton setTintColor:[UIColor whiteColor]];
    [_resetButton setBackgroundColor:[UIColor jc_redColor]];
    [_resetButton setTitle:@"Save Settings" forState:UIControlStateNormal];
    _resetButton.layer.masksToBounds = YES;
    _resetButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_resetButton];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    int labelPadding = 3;
    int padding = 10;
    
    [_oldPasswordLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_oldPasswordLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_oldPasswordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_contentView withOffset:padding];
    
    [_oldPasswordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_oldPasswordField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_oldPasswordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_oldPasswordLabel withOffset:labelPadding];
    
    [_newPasswordLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_newPasswordLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_newPasswordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_oldPasswordField withOffset:padding];
    
    [_newPasswordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_newPasswordField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_newPasswordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_newPasswordLabel withOffset:labelPadding];
    
    [_confirmPasswordLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_confirmPasswordLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_confirmPasswordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_oldPasswordField withOffset:padding];
    
    [_confirmPasswordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_confirmPasswordField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_confirmPasswordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_confirmPasswordLabel withOffset:labelPadding];
    
    [_submitButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_submitButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_submitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_confirmPasswordField withOffset:padding];
    
    [_resetButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_resetButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_resetButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_submitButton withOffset:padding];
    
    [super layoutSubviews];
}


@end
