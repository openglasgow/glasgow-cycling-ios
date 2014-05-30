//
//  JCSettingsView.h
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FDTake/FDTakeController.h>
#import "JCTextField.h"
#import "JCSettingsViewModel.h"

@interface JCSettingsView : UIView  <UIPickerViewDataSource, UIPickerViewDelegate,
UITextFieldDelegate, FDTakeDelegate>

@property (strong, nonatomic) FDTakeController *takeController;

@property (strong, nonatomic) UIScrollView *contentView;

@property (strong, nonatomic) JCSettingsViewModel *viewModel;
@property (strong, nonatomic) JCTextField *emailField;
@property (strong, nonatomic) JCTextField *passwordField;
@property (strong, nonatomic) JCTextField *firstNameField;
@property (strong, nonatomic) JCTextField *lastNameField;
@property (strong, nonatomic) UIButton *profilePictureButton;

// Gender Picker
@property (strong, nonatomic) JCTextField *genderField;
@property (strong, nonatomic) UIButton *genderToolbarButton;
@property (nonatomic, retain) UIToolbar *genderToolbar;
@property (nonatomic, retain) UIPickerView *genderPicker;

// labels
@property (strong, nonatomic) UILabel *nameFieldLabel;
@property (strong, nonatomic) UILabel *emailFieldLabel;
@property (strong, nonatomic) UILabel *genderFieldLabel;

@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *passwordButton;
@property (strong, nonatomic) UIButton *logoutButton;

- (id)initWithViewModel:(JCSettingsViewModel *)settingsViewModel;

@end
