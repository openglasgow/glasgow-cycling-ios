//
//  JCSignupView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLoadingView.h"
@class JCSignupViewModel, JCTextField;

@interface JCSignupView : UIView <UIPickerViewDataSource, UIPickerViewDelegate,
                                            UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *contentView;

@property (strong, nonatomic) JCSignupViewModel *viewModel;
@property (strong, nonatomic) JCTextField *emailField;
@property (strong, nonatomic) JCTextField *passwordField;
@property (strong, nonatomic) JCTextField *firstNameField;
@property (strong, nonatomic) JCTextField *lastNameField;
@property (strong, nonatomic) UIButton *profilePictureButton;
@property (strong, nonatomic) UIButton *signupButton;

// Year of birth picker
@property (strong, nonatomic) JCTextField *yobField;
@property (strong, nonatomic) UIButton *yobToolbarButton;
@property (nonatomic, retain) UIToolbar *yobToolbar;
@property (nonatomic, retain) UIPickerView *yobPicker;

// Gender Picker
@property (strong, nonatomic) JCTextField *genderField;
@property (strong, nonatomic) UIButton *genderToolbarButton;
@property (nonatomic, retain) UIToolbar *genderToolbar;
@property (nonatomic, retain) UIPickerView *genderPicker;

//labels
@property (strong, nonatomic) UILabel *nameFieldLabel;
@property (strong, nonatomic) UILabel *emailFieldLabel;
@property (strong, nonatomic) UILabel *passwordFieldLabel;
@property (strong, nonatomic) UILabel *genderFieldLabel;
@property (strong, nonatomic) UILabel *yobFieldLabel;

@property (strong, nonatomic) JCLoadingView *loadingView;
@property (strong, nonatomic) UIView *bottomArea;

- (id)initWithViewModel:(JCSignupViewModel *)signupViewModel;

@end
