//
//  JCSignupView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FDTake/FDTakeController.h>
@class JCSignupViewModel, JCTextField;

@interface JCSignupView : UIView <UIPickerViewDataSource, UIPickerViewDelegate,
                                            UITextFieldDelegate, FDTakeDelegate>

@property (strong, nonatomic) FDTakeController *takeController;

@property (strong, nonatomic) JCSignupViewModel *viewModel;
@property (strong, nonatomic) JCTextField *emailField;
@property (strong, nonatomic) JCTextField *passwordField;
@property (strong, nonatomic) JCTextField *firstNameField;
@property (strong, nonatomic) JCTextField *lastNameField;
@property (strong, nonatomic) UIButton *profilePictureButton;

// Date picker
@property (strong, nonatomic) JCTextField *dobField;
@property (strong, nonatomic) UIButton *dobToolbarButton;
@property (nonatomic, retain) UIToolbar *dobToolbar;
@property (nonatomic, retain) UIDatePicker *dobPicker;

// Gender Picker
@property (strong, nonatomic) JCTextField *genderField;
@property (strong, nonatomic) UIButton *genderToolbarButton;
@property (nonatomic, retain) UIToolbar *genderToolbar;
@property (nonatomic, retain) UIPickerView *genderPicker;

- (id)initWithFrame:(CGRect)frame viewModel:(JCSignupViewModel *)signupViewModel;
@end
