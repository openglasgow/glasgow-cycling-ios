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

@implementation JCSignupView
@synthesize viewModel;
@synthesize emailField, passwordField, firstNameField, lastNameField, DOBField, genderField, pictureField, DOBPicker, DOBToolbar, DOBToolbarButton;

- (id)initWithFrame:(CGRect)frame viewModel:(JCSignupViewModel *)signupViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.viewModel = signupViewModel;
    
    
    //Setting up DOB DatePicker for DOBField use
    self.DOBPicker = [[UIDatePicker alloc] initWithFrame:[self bounds]];
    self.DOBPicker.datePickerMode = UIDatePickerModeDate;
    self.DOBToolbarButton = [[UIButton alloc] init];
    [self.DOBToolbarButton setTitle:@"Enter" forState:UIControlStateNormal];
    [self.DOBToolbarButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    self.DOBToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.DOBToolbar addSubview:self.DOBToolbarButton];
    [self.DOBToolbarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.DOBToolbar).with.offset(-12);
        make.top.equalTo(self.DOBToolbar);
    }];
    
    self.DOBToolbarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"button press");
        [self.DOBField resignFirstResponder];
        return [RACSignal empty];
    }];
    
    // Form elements
    self.firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.firstNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.firstNameField setPlaceholder:@"First Name"];
    RAC(self.viewModel, firstName) = self.firstNameField.rac_textSignal;
    [self addSubview:self.firstNameField];

    self.lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.lastNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.lastNameField setPlaceholder:@"Last Name"];
    RAC(self.viewModel, lastName) = self.lastNameField.rac_textSignal;
    [self addSubview:self.lastNameField];

    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.emailField setUserInteractionEnabled:YES];
    [self.emailField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.emailField setPlaceholder:@"Your Email"];
    [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    RAC(self.viewModel, email) = self.emailField.rac_textSignal;
    [self addSubview:self.emailField];

    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setPlaceholder:@"New Password"];
    RAC(self.viewModel, password) = self.passwordField.rac_textSignal;
    [self addSubview:self.passwordField];
    
    self.DOBField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.DOBField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.DOBField setPlaceholder:@"Date of Birth"];
    RAC(self.viewModel, DOB) = self.DOBField.rac_textSignal;
    self.DOBField.inputView = self.DOBPicker;
    self.DOBField.inputAccessoryView = self.DOBToolbar;
    [self addSubview:self.DOBField];
    RACChannelTerminal *dobChannel = [self.DOBPicker rac_newDateChannelWithNilValue:nil];
    [dobChannel subscribeNext:^(id dob) {
        NSLog(@"Date: %@", dob);
        [self.viewModel setDOB:dob]; //TODO viewmodel => nsdate
    }];
    
    self.genderField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.genderField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.genderField setPlaceholder:@"Gender"];
    RAC(self.viewModel, gender) = self.genderField.rac_textSignal;
    [self addSubview:self.genderField];
    
    self.pictureField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.pictureField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.pictureField setPlaceholder:@"Picture"];
    RAC(self.viewModel, picture) = self.pictureField.rac_textSignal;
    [self addSubview:self.pictureField];

    // Form positioning
    int padding = 15;

//    [self.firstNameField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(padding);
//        make.right.equalTo(self).with.offset(-padding);
//        make.top.equalTo(self.mas_top).with.offset(padding);
//    }];
//
//    [self.lastNameField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(padding);
//        make.right.equalTo(self).with.offset(-padding);
//        make.top.equalTo(self.firstNameField.mas_bottom).with.offset(padding);
//    }];
//
//    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(padding);
//        make.right.equalTo(self).with.offset(-padding);
//        make.top.equalTo(self.lastNameField.mas_bottom).with.offset(padding);
//    }];

    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.emailField.mas_bottom).with.offset(padding);
    }];
    
    [self.DOBField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.passwordField.mas_bottom).with.offset(padding);
    }];
    
    [self.genderField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.DOBField.mas_bottom).with.offset(padding);
    }];
    
    [self.pictureField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.genderField.mas_bottom).with.offset(padding);
    }];

    return self;
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
