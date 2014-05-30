//
//  JCPasswordView.h
//  JourneyCapture
//
//  Created by Michael Hayes on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTextField.h"
#import "JCPasswordViewModel.h"

@interface JCPasswordView : UIView

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UILabel *oldPasswordLabel;
@property (strong, nonatomic) UILabel *updatedPasswordLabel;
@property (strong, nonatomic) UILabel *confirmPasswordLabel;
@property (strong, nonatomic) JCTextField *oldPasswordField;
@property (strong, nonatomic) JCTextField *updatedPasswordField;
@property (strong, nonatomic) JCTextField *confirmPasswordField;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) JCPasswordViewModel *viewModel;

- (id)initWithViewModel:(JCPasswordViewModel *)passwordViewModel;

@end
