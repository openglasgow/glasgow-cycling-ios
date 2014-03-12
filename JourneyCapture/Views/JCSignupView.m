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
#import "Flurry.h"

@implementation JCSignupView
@synthesize viewModel;
@synthesize emailField, passwordField, firstNameField, lastNameField, dobField, genderField, profilePictureButton, dobPicker, dobToolbar, dobToolbarButton, genderPicker, genderToolbar, genderToolbarButton, takeController;

- (id)initWithFrame:(CGRect)frame viewModel:(JCSignupViewModel *)signupViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.viewModel = signupViewModel;
    
    //Setting up dob DatePicker for dobField use
    self.dobPicker = [[UIDatePicker alloc] initWithFrame:[self bounds]];
    self.dobPicker.datePickerMode = UIDatePickerModeDate;
    self.dobToolbarButton = [[UIButton alloc] init];
    [self.dobToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
    [self.dobToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    self.dobToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.dobToolbar addSubview:self.dobToolbarButton];
    [self.dobToolbarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dobToolbar).with.offset(-12);
        make.top.equalTo(self.dobToolbar);
    }];
    
    self.dobToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"button press");
        [self.dobField resignFirstResponder];
        return [RACSignal empty];
    }];
    
    //Setting up gender UIPickerView for genderField
    self.genderPicker = [[UIPickerView alloc] initWithFrame:[self bounds]];
    [self.genderPicker setDataSource:self];
    [self.genderPicker setDelegate:self];
    self.genderToolbarButton = [[UIButton alloc] init];
    [self.genderToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
    [self.genderToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    self.genderToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.genderToolbar addSubview:self.genderToolbarButton];
    [self.genderToolbarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.genderToolbar).with.offset(-12);
        make.top.equalTo(self.genderToolbar);
    }];
    
    self.genderToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"button press");
        [self.genderField resignFirstResponder];
        return [RACSignal empty];
    }];

    int padding = 10;
    int textFieldHeight = 31;

    // Profile picture
    self.profilePictureButton = [[UIButton alloc] init];
    int picSize = 60;
    [self.profilePictureButton setTintColor:self.tintColor];
    UIImage *defaultImage = [UIImage imageNamed:@"default_profile_pic"];
    [self.profilePictureButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
    [RACChannelTo(self.viewModel, profilePicture) subscribeNext:^(id image) {
        if (image) {
            [self.profilePictureButton setBackgroundImage:image forState:UIControlStateNormal];
            [Flurry logEvent:@"User profile picture selected"];
        }
    }];

    // Mask profile pic to hexagon
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"fcd-profile-mask"] CGImage];
    mask.frame = CGRectMake(0, 0, 60, 60);
    self.profilePictureButton.layer.mask = mask;
    self.profilePictureButton.layer.masksToBounds = YES;

    [self addSubview:self.profilePictureButton];

    self.profilePictureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        self.takeController = [[FDTakeController alloc] init];
        [self.takeController setDelegate:self];
        self.takeController.allowsEditingPhoto = YES;
        [self.takeController takePhotoOrChooseFromLibrary];
        return [RACSignal empty];
    }];

    int verticalPicPadding = ((2*textFieldHeight) + padding - picSize) / 2;
    [self.profilePictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.mas_top).with.offset(padding + verticalPicPadding);
        make.width.equalTo(@(picSize));
        make.height.equalTo(@(picSize));
    }];

    // Email
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.emailField setUserInteractionEnabled:YES];
    [self.emailField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.emailField setPlaceholder:@"Your Email"];
    [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    RAC(self.viewModel, email) = self.emailField.rac_textSignal;
    [self addSubview:self.emailField];

    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self.profilePictureButton.mas_left).with.offset(-padding);
        make.top.equalTo(self.mas_top).with.offset(padding);
    }];

    // Password
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setPlaceholder:@"New Password"];
    RAC(self.viewModel, password) = self.passwordField.rac_textSignal;
    [self addSubview:self.passwordField];

    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self.profilePictureButton.mas_left).with.offset(-padding);
        make.top.equalTo(self.emailField.mas_bottom).with.offset(padding);
    }];

    // First name
    self.firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.firstNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.firstNameField setPlaceholder:@"First Name"];
    RAC(self.viewModel, firstName) = self.firstNameField.rac_textSignal;
    [self addSubview:self.firstNameField];

    [self.firstNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self.mas_centerX).with.offset(-padding/2);
        make.top.equalTo(self.passwordField.mas_bottom).with.offset(padding);
    }];

    // Last name
    self.lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.lastNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.lastNameField setPlaceholder:@"Last Name"];
    RAC(self.viewModel, lastName) = self.lastNameField.rac_textSignal;
    [self addSubview:self.lastNameField];

    [self.lastNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).with.offset(padding/2);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.passwordField.mas_bottom).with.offset(padding);
    }];

    // DOB
    self.dobField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.dobField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.dobField setPlaceholder:@"Date of Birth"];
    RAC(self.viewModel, dob) = self.dobField.rac_textSignal;
    self.dobField.inputView = self.dobPicker;
    self.dobField.inputAccessoryView = self.dobToolbar;
    [self addSubview:self.dobField];
    RACChannelTerminal *dobChannel = [self.dobPicker rac_newDateChannelWithNilValue:nil];
    [dobChannel subscribeNext:^(id dob) {
        [self.viewModel setDob:dob]; //TODO viewmodel => nsdate
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *formattedDob = [formatter stringFromDate:dob];
        [self.dobField setText:formattedDob];
    }];

    [self.dobField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self.mas_centerX).with.offset(-padding/2);
        make.top.equalTo(self.lastNameField.mas_bottom).with.offset(padding);
    }];

    // Gender
    self.genderField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.genderField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.genderField setPlaceholder:@"Gender"];
    RACChannelTo(self.viewModel, gender) = RACChannelTo(self.genderField, text);
    self.genderField.inputView = self.genderPicker;
    self.genderField.inputAccessoryView = self.genderToolbar;
    [self.genderField setDelegate:self];
    [self addSubview:self.genderField];

    [self.genderField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).with.offset(padding/2);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.lastNameField.mas_bottom).with.offset(padding);
    }];

    return self;
}

// TODO reactive cocoa instead of delegate/data source?
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.viewModel.genders[row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.viewModel.genders count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.genderField setText:self.viewModel.genders[row]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self pickerView:self.genderPicker didSelectRow:0 inComponent:0];
    }
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    self.viewModel.profilePicture = photo;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
