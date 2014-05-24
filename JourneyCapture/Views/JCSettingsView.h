//
//  JCSettingsView.h
//  JourneyCapture
//
//  Created by Michael Hayes on 23/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTextField.h"
#import <FDTake/FDTakeController.h>

@interface JCSettingsView : UIView

@property (strong, nonatomic) FDTakeController *takeController;

@property (strong, nonatomic) JCTextField *emailField;
@property (strong, nonatomic) JCTextField *firstNameField;
@property (strong, nonatomic) JCTextField *lastNameField;
@property (strong, nonatomic) UIButton *profilePictureButton;
@property (strong, nonatomic) UIButton *enterButton;
@property (strong, nonatomic) UIButton *passwordButton;

// Gender Picker
@property (strong, nonatomic) JCTextField *genderField;
@property (strong, nonatomic) UIButton *genderToolbarButton;
@property (nonatomic, retain) UIToolbar *genderToolbar;
@property (nonatomic, retain) UIPickerView *genderPicker;

//labels
@property (strong, nonatomic) UILabel *nameFieldLabel;
@property (strong, nonatomic) UILabel *emailFieldLabel;
@property (strong, nonatomic) UILabel *genderFieldLabel;

@end
