//
//  JCSigninView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCSigninViewModel;

@interface JCSigninView : UIView
@property (strong, nonatomic) JCSigninViewModel *viewModel;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;

- (id)initWithFrame:(CGRect)frame viewModel:(JCSigninViewModel *)signinViewModel;
@end
