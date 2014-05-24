////
////  JCSettingsView.m
////  JourneyCapture
////
////  Created by Michael Hayes on 23/05/2014.
////  Copyright (c) 2014 FCD. All rights reserved.
////
//
//#import "JCSettingsView.h"
//#import "Flurry.h"
//
//@implementation JCSettingsView
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//    
//    _viewModel = signupViewModel;
//    
//    UIFont *labelFont = [UIFont systemFontOfSize:14];
//    
//    //Setting up gender UIPickerView for genderField
//    _genderPicker = [UIPickerView new];
//    [_genderPicker setDataSource:self];
//    [_genderPicker setDelegate:self];
//    
//    _genderToolbarButton = [UIButton new];
//    [_genderToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
//    [_genderToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
//    _genderToolbarButton.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    _genderToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
//    [_genderToolbar addSubview:_genderToolbarButton];
//    
//    _genderToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [_genderField resignFirstResponder];
//        return [RACSignal empty];
//    }];
//    
//    // Profile picture
//    _profilePictureButton = [UIButton new];
//    _profilePictureButton.translatesAutoresizingMaskIntoConstraints = NO;
//    _profilePictureButton.tintColor = self.tintColor;
//    _profilePictureButton.translatesAutoresizingMaskIntoConstraints = NO;
//    UIImage *defaultImage = [UIImage imageNamed:@"profile-pic-placeholder"];
//    [_profilePictureButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
//    [RACChannelTo(_viewModel, profilePicture) subscribeNext:^(id image) {
//        if (image) {
//            [_profilePictureButton setBackgroundImage:image forState:UIControlStateNormal];
//        }
//    }];
//    [self addSubview:_profilePictureButton];
//    
//    _profilePictureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [Flurry logEvent:@"Signup profile picture selected"];
//        _takeController = [[FDTakeController alloc] init];
//        [_takeController setDelegate:self];
//        _takeController.allowsEditingPhoto = YES;
//        [_takeController takePhotoOrChooseFromLibrary];
//        return [RACSignal empty];
//    }];
//    
//    // Email
//    _emailFieldLabel = [UILabel new];
//    _emailFieldLabel.text = @"Email Address";
//    _emailFieldLabel.font = labelFont;
//    _emailFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_emailFieldLabel];
//    
//    _emailField = [JCTextField new];
//    _emailField.userInteractionEnabled = YES;
//    _emailField.borderStyle = UITextBorderStyleRoundedRect;
//    _emailField.placeholder = @"Your email";
//    _emailField.font = labelFont;
//    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
//    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_emailField];
//    [[_emailField.rac_textSignal skip:1] subscribeNext:^(id x) {
//        _viewModel.email = _emailField.text;
//    }];
//    
//    // Validation and errors
//    [_viewModel.emailValid subscribeNext:^(id emailValid) {
//        _emailField.valid = [emailValid boolValue];
//    }];
//    [RACObserve(_viewModel, emailError) subscribeNext:^(id x) {
//        _emailField.error = _viewModel.emailError.length > 0;
//    }];
//    
//    // First name
//    _nameFieldLabel = [UILabel new];
//    _nameFieldLabel.text = @"Name";
//    _nameFieldLabel.font = labelFont;
//    _nameFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_nameFieldLabel];
//    
//    _firstNameField = [JCTextField new];
//    _firstNameField.borderStyle = UITextBorderStyleRoundedRect;
//    _firstNameField.placeholder = @"First Name";
//    _firstNameField.font = labelFont;
//    _firstNameField.translatesAutoresizingMaskIntoConstraints = NO;
//    RAC(_viewModel, firstName) = _firstNameField.rac_textSignal;
//    [self addSubview:_firstNameField];
//    [_viewModel.firstNameValid subscribeNext:^(id firstNameValid) {
//        _firstNameField.valid = [firstNameValid boolValue];
//    }];
//    
//    // Last name
//    _lastNameField = [JCTextField new];
//    _lastNameField.borderStyle = UITextBorderStyleRoundedRect;
//    _lastNameField.placeholder = @"Last Name";
//    _lastNameField.font = labelFont;
//    _lastNameField.translatesAutoresizingMaskIntoConstraints = NO;
//    RAC(_viewModel, lastName) = _lastNameField.rac_textSignal;
//    [self addSubview:_lastNameField];
//    [_viewModel.lastNameValid subscribeNext:^(id lastNameValid) {
//        _lastNameField.valid = [lastNameValid boolValue];
//    }];
//    
//    RACChannelTerminal *dobChannel = [_dobPicker rac_newDateChannelWithNilValue:nil];
//    [dobChannel subscribeNext:^(id dob) {
//        [_viewModel setDob:dob]; //TODO viewmodel => nsdate
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"dd/MM/yyyy"];
//        NSString *formattedDob = [formatter stringFromDate:dob];
//        [_dobField setText:formattedDob];
//    }];
//    
//    // Gender
//    _genderFieldLabel = [UILabel new];
//    _genderFieldLabel.text = @"Gender";
//    _genderFieldLabel.font = labelFont;
//    _genderFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [_contentView addSubview:_genderFieldLabel];
//    
//    _genderField = [JCTextField new];
//    _genderField.borderStyle = UITextBorderStyleRoundedRect;
//    _genderField.placeholder = @"Gender";
//    _genderField.font = labelFont;
//    _genderField.translatesAutoresizingMaskIntoConstraints = NO;
//    RACChannelTo(_viewModel, gender) = RACChannelTo(_genderField, text);
//    _genderField.inputView = _genderPicker;
//    _genderField.inputAccessoryView = _genderToolbar;
//    _genderField.delegate = self;
//    [_contentView addSubview:_genderField];
//    
//    [_viewModel.genderValid subscribeNext:^(id genderValid) {
//        _genderField.valid = [genderValid boolValue];
//    }];
//    
//    _enterButton = [UIButton new];
//    _enterButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_enterButton setTintColor:[UIColor whiteColor]];
//    [_enterButton setBackgroundColor:[UIColor jc_buttonGreenColor]];
//    [_enterButton setTitle:@"Sign Up" forState:UIControlStateNormal];
//    _enterButton.layer.masksToBounds = YES;
//    _enterButton.layer.cornerRadius = 4.0f;
//    [self addSubview:_enterButton];
//    
//    [_bottomArea addSubview:_loadingView];
//    
//    return self;
//}
//
//#pragma mark - UIView
//
//- (void)layoutSubviews
//{
//    [_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//    
//    [_dobToolbarButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_dobToolbar withOffset:-12];
//    [_dobToolbarButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_dobToolbar];
//    
//    [_genderToolbarButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_genderToolbar withOffset:-12];
//    [_genderToolbarButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_genderToolbar];
//    
//    int labelPadding = 3;
//    int padding = 10;
//    int picSize = 100;
//    
//    [_profilePictureButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_emailFieldLabel withOffset:-padding];
//    [_profilePictureButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
//    [_profilePictureButton autoSetDimensionsToSize:CGSizeMake(picSize, picSize)];
//    
//    [_nameFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView withOffset:padding];
//    [_nameFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    
//    [_firstNameField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameFieldLabel withOffset:labelPadding];
//    [_firstNameField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_firstNameField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_profilePictureButton withOffset:-padding];
//    
//    [_lastNameField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_lastNameField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_profilePictureButton withOffset:-padding];
//    [_lastNameField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_firstNameField withOffset:padding];
//    
//    [_emailFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_emailFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_lastNameField];
//    [_emailFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lastNameField withOffset:padding];
//    
//    [_emailField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_emailField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
//    [_emailField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailFieldLabel withOffset:labelPadding];
//    
//    [_passwordFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_passwordFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_passwordField];
//    [_passwordFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_emailField withOffset:padding];
//    
//    [_passwordField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_passwordField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
//    [_passwordField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordFieldLabel withOffset:labelPadding];
//    
//    [_dobFieldLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_dobFieldLabel autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:-padding/2];
//    [_dobFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:padding];
//    
//    [_dobField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_dobField autoConstrainAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:-padding/2];
//    [_dobField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_dobFieldLabel withOffset:labelPadding];
//    
//    [_genderFieldLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
//    [_genderFieldLabel autoConstrainAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:padding/2];
//    [_genderFieldLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_passwordField withOffset:padding];
//    
//    [_genderField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
//    [_genderField autoConstrainAttribute:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeCenterX ofView:_contentView withOffset:padding/2];
//    [_genderField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_genderFieldLabel withOffset:labelPadding];
//    
//    [_signupButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:padding];
//    [_signupButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-padding];
//    [_signupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_genderField withOffset:padding];
//    [_signupButton autoSetDimension:ALDimensionWidth toSize:320 - (2*padding)];
//    
//    [_bottomArea autoSetDimension:ALDimensionHeight toSize:250.0f];
//    [_bottomArea autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:0];
//    [_bottomArea autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:0];
//    [_bottomArea autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_signupButton withOffset:padding];
//    [_bottomArea autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_contentView];
//    
//    [_loadingView autoRemoveConstraintsAffectingView];
//    [_loadingView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bottomArea withOffset:150];
//    [_loadingView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    
//    [super layoutSubviews];
//}
//
//#pragma mark - UIPickerViewDelegate
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return _viewModel.genders[row];
//}
//
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return [_viewModel.genders count];
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    [_genderField setText:_viewModel.genders[row]];
//}
//
//#pragma mark - UITextFieldDelegate
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField.text.length == 0) {
//        [self pickerView:_genderPicker didSelectRow:0 inComponent:0];
//    }
//    
//    CGFloat offset = 100;
//    CGPoint scrollPoint = CGPointMake(0.0, offset);
//    [_contentView setContentOffset:scrollPoint animated:YES];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    CGFloat offset = 0;
//    CGPoint scrollPoint = CGPointMake(0.0, offset);
//    [_contentView setContentOffset:scrollPoint animated:YES];
//}
//
//#pragma mark - FDTakeControllerDelegate
//
//- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
//{
//    _viewModel.profilePicture = photo;
//}
//
//
//@end
//
//
//@end
