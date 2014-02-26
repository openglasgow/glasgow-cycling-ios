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
@synthesize emailField, passwordField, firstNameField, lastNameField;

- (id)initWithFrame:(CGRect)frame viewModel:(JCSignupViewModel *)signupViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.viewModel = signupViewModel;
    
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
    RAC(self.viewModel, email) = self.emailField.rac_textSignal;
    [self addSubview:self.emailField];

    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 31)];
    [self.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setPlaceholder:@"New Password"];
    RAC(self.viewModel, password) = self.passwordField.rac_textSignal;
    [self addSubview:self.passwordField];

    // Form positioning
    int padding = 15;

    [self.firstNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.mas_top).with.offset(padding);
    }];

    [self.lastNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.firstNameField.mas_bottom).with.offset(padding);
    }];

    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.lastNameField.mas_bottom).with.offset(padding);
    }];

    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(padding);
        make.right.equalTo(self).with.offset(-padding);
        make.top.equalTo(self.emailField.mas_bottom).with.offset(padding);
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
