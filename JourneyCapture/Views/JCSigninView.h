//
//  JCSigninView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCSigninViewModel, JCTextField;

@interface JCSigninView : UIView
@property (strong, nonatomic) JCSigninViewModel *viewModel;
@property (strong, nonatomic) JCTextField *emailField;
@property (strong, nonatomic) JCTextField *passwordField;

- (id)initWithViewModel:(JCSigninViewModel *)signinViewModel;
@end
