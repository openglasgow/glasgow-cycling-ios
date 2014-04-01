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

    //Setting up dob DatePicker for dobField use
    _dobPicker = [UIDatePicker new];
    _dobPicker.datePickerMode = UIDatePickerModeDate;

    _dobToolbarButton = [UIButton new];
    [_dobToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
    [_dobToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _dobToolbarButton.translatesAutoresizingMaskIntoConstraints = NO;

    _dobToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [_dobToolbar addSubview:_dobToolbarButton];

    _dobToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_dobField resignFirstResponder];
        return [RACSignal empty];
    }];

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
    _profilePictureButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *defaultImage = [UIImage imageNamed:@"default_profile_pic"];
    [_profilePictureButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
    [RACChannelTo(_viewModel, profilePicture) subscribeNext:^(id image) {
        if (image) {
            [_profilePictureButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];

    // Mask profile pic with hexagon
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"fcd-profile-mask"] CGImage];
    mask.frame = CGRectMake(0, 0, 60, 60);
    _profilePictureButton.layer.mask = mask;
    _profilePictureButton.layer.masksToBounds = YES;
    [self addSubview:_profilePictureButton];

    _profilePictureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [Flurry logEvent:@"Signup profile picture selected"];
        _takeController = [[FDTakeController alloc] init];
        [_takeController setDelegate:self];
        _takeController.allowsEditingPhoto = YES;
        [_takeController takePhotoOrChooseFromLibrary];
        return [RACSignal empty];
    }];

    // Email
    _emailField = [JCTextField new];
    _emailField.userInteractionEnabled = YES;
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.placeholder = @"Your email";
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, email) = _emailField.rac_textSignal;
    [self addSubview:_emailField];

    // Validation and errors
    [_viewModel.emailValid subscribeNext:^(id emailValid) {
        _emailField.valid = [emailValid boolValue];
    }];
    RACChannelTo(_viewModel, emailError) = RACChannelTo(_emailField, error);

    // Password
    _passwordField = [JCTextField new];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"New Password";
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, password) = _passwordField.rac_textSignal;
    [self addSubview:_passwordField];

    // Validation and errors
    [_viewModel.passwordValid subscribeNext:^(id passwordValid) {
        _passwordField.valid = [passwordValid boolValue];
    }];
    RACChannelTo(_viewModel, passwordError) = RACChannelTo(_passwordField, error);

    // First name
    _firstNameField = [JCTextField new];
    _firstNameField.borderStyle = UITextBorderStyleRoundedRect;
    _firstNameField.placeholder = @"First Name";
    _firstNameField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, firstName) = _firstNameField.rac_textSignal;
    [self addSubview:_firstNameField];
    [_viewModel.firstNameValid subscribeNext:^(id firstNameValid) {
        _firstNameField.valid = [firstNameValid boolValue];
    }];

    // Last name
    _lastNameField = [JCTextField new];
    _lastNameField.borderStyle = UITextBorderStyleRoundedRect;
    _lastNameField.placeholder = @"Last Name";
    _lastNameField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, lastName) = _lastNameField.rac_textSignal;
    [self addSubview:_lastNameField];
    [_viewModel.lastNameValid subscribeNext:^(id lastNameValid) {
        _lastNameField.valid = [lastNameValid boolValue];
    }];

    // DOB
    _dobField = [JCTextField new];
    _dobField.borderStyle = UITextBorderStyleRoundedRect;
    _dobField.placeholder = @"Date of Birth";
    _dobField.translatesAutoresizingMaskIntoConstraints = NO;
    RAC(_viewModel, dob) = _dobField.rac_textSignal;
    _dobField.inputView = _dobPicker;
    _dobField.inputAccessoryView = _dobToolbar;
    [self addSubview:_dobField];

    [_viewModel.dobValid subscribeNext:^(id dobValid) {
        _dobField.valid = [dobValid boolValue];
    }];

    RACChannelTerminal *dobChannel = [_dobPicker rac_newDateChannelWithNilValue:nil];
    [dobChannel subscribeNext:^(id dob) {
        [_viewModel setDob:dob]; //TODO viewmodel => nsdate
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *formattedDob = [formatter stringFromDate:dob];
        [_dobField setText:formattedDob];
    }];

    // Gender
    _genderField = [JCTextField new];
    _genderField.borderStyle = UITextBorderStyleRoundedRect;
    _genderField.placeholder = @"Gender";
    _genderField.translatesAutoresizingMaskIntoConstraints = NO;
    RACChannelTo(_viewModel, gender) = RACChannelTo(_genderField, text);
    _genderField.inputView = _genderPicker;
    _genderField.inputAccessoryView = _genderToolbar;
    [_genderField setDelegate:self];
    [self addSubview:_genderField];

    [_viewModel.genderValid subscribeNext:^(id genderValid) {
        _genderField.valid = [genderValid boolValue];
    }];

    return self;
}

- (void)layoutSubviews
{
    [_dobToolbarButton autoRemoveConstraintsAffectingView];
    [_dobToolbarButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_dobToolbar withOffset:-12];
    [_dobToolbarButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_dobToolbar];

    [_genderToolbarButton autoRemoveConstraintsAffectingView];
    [_genderToolbarButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_genderToolbar withOffset:-12];
    [_genderToolbarButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_genderToolbar];

    int padding = 10;
    int textFieldHeight = 31;
    int picSize = 60;
    int verticalPicPadding = ((2*textFieldHeight) + padding - picSize) / 2;
    [_profilePictureButton autoRemoveConstraintsAffectingView];
    [_profilePictureButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:padding + verticalPicPadding];
    [_profilePictureButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_profilePictureButton autoSetDimensionsToSize:CGSizeMake(picSize, picSize)];

    [_emailField autoRemoveConstraintsAffectingView];
    [_emailField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:padding];
    [_emailField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_emailField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_profilePictureButton withOffset:-padding];
    [_emailField layoutError];

    [_passwordField autoRemoveConstraintsAffectingView];
    [_passwordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_passwordField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_profilePictureButton withOffset:-padding];
    [_passwordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailField withOffset:padding];
    [_passwordField layoutError];

    [_firstNameField autoRemoveConstraintsAffectingView];
    [_firstNameField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_firstNameField autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:self withOffset:-padding/2];
    [_firstNameField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:padding];
    [_firstNameField layoutError];

    [_lastNameField autoRemoveConstraintsAffectingView];
    [_lastNameField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_lastNameField autoConstrainAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeCenterX ofView:self withOffset:padding/2];
    [_lastNameField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:padding];
    [_lastNameField layoutError];

    [_dobField autoRemoveConstraintsAffectingView];
    [_dobField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_dobField autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:self withOffset:-padding/2];
    [_dobField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lastNameField withOffset:padding];
    [_dobField layoutError];

    [_genderField autoRemoveConstraintsAffectingView];
    [_genderField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-padding];
    [_genderField autoConstrainAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeCenterX ofView:self withOffset:padding/2];
    [_genderField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lastNameField withOffset:padding];
    [_genderField layoutError];

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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self pickerView:_genderPicker didSelectRow:0 inComponent:0];
    }
}

#pragma mark - FDTakeControllerDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    _viewModel.profilePicture = photo;
}


@end
