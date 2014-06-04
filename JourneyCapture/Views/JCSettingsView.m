//
//  JCSettingsView.m
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSettingsView.h"
#import "JCSettingsViewModel.h"
#import "Flurry.h"

@implementation JCSettingsView

- (id)initWithViewModel:(JCSettingsViewModel *)settingsViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _viewModel = settingsViewModel;
    
    UIFont *labelFont = [UIFont systemFontOfSize:14];
    
    // Content scroll view
    _contentView = [UIScrollView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: _contentView];
    
    //Setting up gender UIPickerView for genderField
    _genderPicker = [UIPickerView new];
    [_genderPicker setDataSource:self];
    [_genderPicker setDelegate:self];
    
    _genderToolbarButton = [UIButton new];
    [_genderToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
    [_genderToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _genderToolbarButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    _genderToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [_genderToolbar addSubview:_genderToolbarButton];
    
    _genderToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_genderField resignFirstResponder];
        return [RACSignal empty];
    }];
    
    // Profile picture
    _profilePictureButton = [UIButton new];
    _profilePictureButton.translatesAutoresizingMaskIntoConstraints = NO;
    _profilePictureButton.tintColor = self.tintColor;
    _profilePictureButton.layer.masksToBounds = YES;
    _profilePictureButton.layer.cornerRadius = 50.0f;
    _profilePictureButton.backgroundColor = [UIColor jc_blueColor];
    UIImage *defaultImage = [UIImage imageNamed:@"profile-pic-placeholder"];
    [_profilePictureButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
    [RACChannelTo(_viewModel, profilePic) subscribeNext:^(id image) {
        if (image) {
            [_profilePictureButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    [_contentView addSubview:_profilePictureButton];
    
    // Email
    _emailFieldLabel = [UILabel new];
    _emailFieldLabel.text = @"Email Address";
    _emailFieldLabel.font = labelFont;
    _emailFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_emailFieldLabel];
    
    _emailField = [JCTextField new];
    _emailField.userInteractionEnabled = YES;
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.text = _viewModel.email;
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
    [RACObserve(self, viewModel.emailError) subscribeNext:^(NSString *error) {
        _emailField.error = error.length > 0;
    }];
    
    // First name
    _nameFieldLabel = [UILabel new];
    _nameFieldLabel.text = @"Name";
    _nameFieldLabel.font = labelFont;
    _nameFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_nameFieldLabel];
    
    _firstNameField = [JCTextField new];
    _firstNameField.borderStyle = UITextBorderStyleRoundedRect;
    _firstNameField.text = _viewModel.firstName;
    _firstNameField.font = labelFont;
    _firstNameField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, firstName) = _firstNameField.rac_textSignal;
    [_contentView addSubview:_firstNameField];
    [RACObserve(self, viewModel.firstNameError) subscribeNext:^(NSString *error) {
        _firstNameField.error = error.length > 0;
    }];
    
    // Last name
    _lastNameField = [JCTextField new];
    _lastNameField.borderStyle = UITextBorderStyleRoundedRect;
    _lastNameField.text = _viewModel.lastName;
    _lastNameField.font = labelFont;
    _lastNameField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, lastName) = _lastNameField.rac_textSignal;
    [_contentView addSubview:_lastNameField];
    [RACObserve(self, viewModel.lastNameError) subscribeNext:^(NSString *error) {
        _lastNameField.error = error.length > 0;
    }];
    
    // Gender
    _genderFieldLabel = [UILabel new];
    _genderFieldLabel.text = @"Gender";
    _genderFieldLabel.font = labelFont;
    _genderFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_genderFieldLabel];
    
    _genderField = [JCTextField new];
    _genderField.borderStyle = UITextBorderStyleRoundedRect;
    _genderField.text = _viewModel.gender;
    _genderField.font = labelFont;
    _genderField.translatesAutoresizingMaskIntoConstraints = NO;
    RACChannelTo(_viewModel, gender) = RACChannelTo(_genderField, text);
    _genderField.inputView = _genderPicker;
    _genderField.inputAccessoryView = _genderToolbar;
    _genderField.delegate = self;
    [_contentView addSubview:_genderField];
    
    [_viewModel.genderValid subscribeNext:^(id genderValid) {
        _genderField.valid = [genderValid boolValue];
    }];

    _submitButton = [UIButton new];
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_submitButton setTintColor:[UIColor whiteColor]];
    [_submitButton setBackgroundColor:[UIColor jc_buttonGreenColor]];
    [_submitButton setTitle:@"Save Settings" forState:UIControlStateNormal];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_submitButton];
    
    _passwordButton = [UIButton new];
    _passwordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_passwordButton setTintColor:[UIColor whiteColor]];
    [_passwordButton setBackgroundColor:[UIColor jc_blueColor]];
    [_passwordButton setTitle:@"Change Password" forState:UIControlStateNormal];
    _passwordButton.layer.masksToBounds = YES;
    _passwordButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_passwordButton];
    
    _logoutButton = [UIButton new];
    _logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_logoutButton setTintColor:[UIColor whiteColor]];
    [_logoutButton setBackgroundColor:[UIColor jc_redColor]];
    [_logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    _logoutButton.layer.masksToBounds = YES;
    _logoutButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_logoutButton];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
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
    
    [_genderFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_genderFieldLabel autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:padding/2];
    [_genderFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailField withOffset:padding];
    
    [_genderField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_genderField autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:_contentView];
    [_genderField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_genderFieldLabel withOffset:labelPadding];
    
    [_submitButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_submitButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_submitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_genderField withOffset:(3*padding)];
    [_submitButton autoSetDimension:ALDimensionWidth toSize:320 - (2*padding)];

    [_passwordButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_passwordButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_passwordButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_submitButton withOffset:15];
    
    [_logoutButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
    [_logoutButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
    [_logoutButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordButton withOffset:15];
    
    [super layoutSubviews];
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _viewModel.genders[row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_viewModel.genders count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_genderField setText:_viewModel.genders[row]];
}


@end
