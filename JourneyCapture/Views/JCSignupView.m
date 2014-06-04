//
//  JCSignupView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSignupView.h"
#import "JCSignupViewModel.h"
#import <QuartzCore/QuartzCore.h>
#import "JCTextField.h"
#import "Flurry.h"

@implementation JCSignupView

- (id)initWithViewModel:(JCSignupViewModel *)signupViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _viewModel = signupViewModel;
    
    UIFont *labelFont = [UIFont systemFontOfSize:14];

    // Content scroll view
    _contentView = [UIScrollView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: _contentView];

    // Profile picture
    _profilePictureButton = [UIButton new];
    _profilePictureButton.translatesAutoresizingMaskIntoConstraints = NO;
    _profilePictureButton.tintColor = self.tintColor;
    _profilePictureButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *defaultImage = [UIImage imageNamed:@"profile-pic-placeholder"];
    [_profilePictureButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
    [RACChannelTo(_viewModel, profilePicture) subscribeNext:^(id image) {
        if (image) {
            [_profilePictureButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    [_contentView addSubview:_profilePictureButton];

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
    _emailField.placeholder = @"Your email";
    _emailField.font = labelFont;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_emailField];
    [[_emailField.rac_textSignal skip:1] subscribeNext:^(id x) {
        _viewModel.email = _emailField.text;
    }];
    
    // Validation and errors
    [_viewModel.emailValid subscribeNext:^(id emailValid) {
        _emailField.valid = [emailValid boolValue];
    }];
    [RACObserve(_viewModel, emailError) subscribeNext:^(id x) {
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
    _passwordField.placeholder = @"New Password";
    _passwordField.font = labelFont;
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    _passwordField.delegate = self;
    RAC(_viewModel, password) = _passwordField.rac_textSignal;
    [_contentView addSubview:_passwordField];

    // Validation and errors
    [_viewModel.passwordValid subscribeNext:^(id passwordValid) {
        _passwordField.valid = [passwordValid boolValue];
    }];
    [RACObserve(_viewModel, passwordError) subscribeNext:^(id x) {
        _passwordField.error = _viewModel.passwordError.length > 0;
    }];

    // First name
    _nameFieldLabel = [UILabel new];
    _nameFieldLabel.text = @"Name";
    _nameFieldLabel.font = labelFont;
    _nameFieldLabel.textColor = [UIColor jc_darkGrayColor];
    _nameFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_nameFieldLabel];
    
    _firstNameField = [JCTextField new];
    _firstNameField.borderStyle = UITextBorderStyleRoundedRect;
    _firstNameField.placeholder = @"First Name";
    _firstNameField.font = labelFont;
    _firstNameField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, firstName) = _firstNameField.rac_textSignal;
    [_contentView addSubview:_firstNameField];
    [_viewModel.firstNameValid subscribeNext:^(id firstNameValid) {
        _firstNameField.valid = [firstNameValid boolValue];
    }];

    // Last name
    _lastNameField = [JCTextField new];
    _lastNameField.borderStyle = UITextBorderStyleRoundedRect;
    _lastNameField.placeholder = @"Last Name";
    _lastNameField.font = labelFont;
    _lastNameField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, lastName) = _lastNameField.rac_textSignal;
    [_contentView addSubview:_lastNameField];
    [_viewModel.lastNameValid subscribeNext:^(id lastNameValid) {
        _lastNameField.valid = [lastNameValid boolValue];
    }];

    // Year of Birth
    _yobFieldLabel = [UILabel new];
    _yobFieldLabel.text = @"Year of Birth";
    _yobFieldLabel.font = labelFont;
    _yobFieldLabel.textColor = [UIColor jc_darkGrayColor];
    _yobFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_yobFieldLabel];
    
    _yobField = [JCTextField new];
    _yobField.borderStyle = UITextBorderStyleRoundedRect;
    _yobField.placeholder = @"Year of Birth";
    _yobField.font = labelFont;
    _yobField.translatesAutoresizingMaskIntoConstraints = NO;
    _yobField.delegate = self;
    [_yobField.rac_textSignal subscribeNext:^(NSString *text) {
        NSUInteger year = [text intValue];
        _viewModel.yearOfBirth = year;
    }];
    [_contentView addSubview:_yobField];

    [_viewModel.yobValid subscribeNext:^(id dobValid) {
        _yobField.valid = [dobValid boolValue];
    }];
    
    // Year of birth picker
    _yobPicker = [UIPickerView new];
    _yobPicker.delegate = self;
    _yobPicker.dataSource = self;
    
    _yobToolbarButton = [UIButton new];
    [_yobToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
    [_yobToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _yobToolbarButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    _yobToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [_yobToolbar addSubview:_yobToolbarButton];
    
    _yobField.inputView = _yobPicker;
    _yobField.inputAccessoryView = _yobToolbar;
    
    _yobToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_yobField resignFirstResponder];
        return [RACSignal empty];
    }];

    // Gender
    _genderFieldLabel = [UILabel new];
    _genderFieldLabel.text = @"Gender";
    _genderFieldLabel.font = labelFont;
    _genderFieldLabel.textColor = [UIColor jc_darkGrayColor];
    _genderFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_genderFieldLabel];
    
    _genderField = [JCTextField new];
    _genderField.borderStyle = UITextBorderStyleRoundedRect;
    _genderField.placeholder = @"Gender";
    _genderField.font = labelFont;
    _genderField.translatesAutoresizingMaskIntoConstraints = NO;
    RACChannelTo(_viewModel, gender) = RACChannelTo(_genderField, text);
    _genderField.delegate = self;
    [_contentView addSubview:_genderField];

    [_viewModel.genderValid subscribeNext:^(id genderValid) {
        _genderField.valid = [genderValid boolValue];
    }];
    
    // Gender picker
    _genderPicker = [UIPickerView new];
    [_genderPicker setDataSource:self];
    [_genderPicker setDelegate:self];
    
    _genderToolbarButton = [UIButton new];
    [_genderToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
    [_genderToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _genderToolbarButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    _genderField.inputView = _genderPicker;
    _genderField.inputAccessoryView = _genderToolbar;
    
    _genderToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [_genderToolbar addSubview:_genderToolbarButton];
    
    _genderToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_genderField resignFirstResponder];
        return [RACSignal empty];
    }];
    
    // Signup button
    _signupButton = [UIButton new];
    _signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_signupButton setTintColor:[UIColor whiteColor]];
    [_signupButton setBackgroundColor:[UIColor jc_buttonGreenColor]];
    [_signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    _signupButton.layer.masksToBounds = YES;
    _signupButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_signupButton];
    
    // Blue loading area
    _bottomArea = [UIView new];
    [_bottomArea setBackgroundColor:[UIColor whiteColor]];
    _bottomArea.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_bottomArea];
    
    _loadingView = [JCLoadingView new];
    [_loadingView setBikerBlue];
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    _loadingView.infoLabel.text = @"";
    
    [_bottomArea addSubview:_loadingView];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [_yobToolbarButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_yobToolbar withOffset:-12];
    [_yobToolbarButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_yobToolbar];

    [_genderToolbarButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_genderToolbar withOffset:-12];
    [_genderToolbarButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_genderToolbar];

    int labelPadding = 3;
    int padding = 10;
    int picSize = 100;
    
    [_profilePictureButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_emailFieldLabel withOffset:-padding];
    [_profilePictureButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_profilePictureButton autoSetDimensionsToSize:CGSizeMake(picSize, picSize)];

    [_nameFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView withOffset:padding];
    [_nameFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    
    [_firstNameField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameFieldLabel withOffset:labelPadding];
    [_firstNameField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_firstNameField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_profilePictureButton withOffset:-padding];

    [_lastNameField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_lastNameField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_profilePictureButton withOffset:-padding];
    [_lastNameField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_firstNameField withOffset:padding];

    [_emailFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_emailFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_lastNameField];
    [_emailFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lastNameField withOffset:padding];

    [_emailField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_emailField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_emailField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailFieldLabel withOffset:labelPadding];
    
    [_passwordFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_passwordFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passwordField];
    [_passwordFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailField withOffset:padding];

    [_passwordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_passwordField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_passwordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordFieldLabel withOffset:labelPadding];
    
    [_yobFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_yobFieldLabel autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:-padding/2];
    [_yobFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:padding];

    [_yobField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_yobField autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:-padding/2];
    [_yobField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_yobFieldLabel withOffset:labelPadding];
    
    [_genderFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_genderFieldLabel autoConstrainAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:padding/2];
    [_genderFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:padding];

    [_genderField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_genderField autoConstrainAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:padding/2];
    [_genderField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_genderFieldLabel withOffset:labelPadding];
    
    [_signupButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_signupButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_signupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_genderField withOffset:padding];
    [_signupButton autoSetDimension:ALDimensionWidth toSize:320 - (2*padding)];
    
    [_bottomArea autoSetDimension:ALDimensionHeight toSize:250.0f];
    [_bottomArea autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:0];
    [_bottomArea autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:0];
    [_bottomArea autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_signupButton withOffset:padding];
    [_bottomArea autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_contentView];
    
    [_loadingView autoRemoveConstraintsAffectingView];
    [_loadingView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bottomArea withOffset:150];
    [_loadingView autoAlignAxisToSuperviewAxis:ALAxisVertical];

    [super layoutSubviews];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _genderPicker) {
        return _viewModel.genders[row];
    } else {
        return _viewModel.birthYears[row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _genderPicker) {
        return [_viewModel.genders count];
    } else {
        return [_viewModel.birthYears count];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _genderPicker) {
        [_genderField setText:_viewModel.genders[row]];
    } else {
        [_yobField setText:_viewModel.birthYears[row]];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if (textField == _genderField) {
            [_genderPicker selectRow:0 inComponent:0 animated:NO];
            [self pickerView:_genderPicker didSelectRow:0 inComponent:0];
        } else if (textField == _yobField) {
            [_yobPicker selectRow:90 inComponent:0 animated:NO];
            [self pickerView:_yobPicker didSelectRow:90 inComponent:0];
            _viewModel.yearOfBirth = [_viewModel.birthYears[90] intValue];
        }
    }
    
    CGFloat offset = 100;
    CGPoint scrollPoint = CGPointMake(0.0, offset);
    [_contentView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat offset = 0;
    CGPoint scrollPoint = CGPointMake(0.0, offset);
    [_contentView setContentOffset:scrollPoint animated:YES];
}

@end
