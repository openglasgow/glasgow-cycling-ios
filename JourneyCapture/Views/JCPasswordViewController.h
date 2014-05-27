//
//  JCPasswordViewController.h
//  JourneyCapture
//
//  Created by Michael Hayes on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class JCPasswordViewModel, JCPasswordView;

@interface JCPasswordViewController : UIViewController

@property (strong, nonatomic) JCPasswordViewModel *viewModel;
@property (strong, nonatomic) JCPasswordView *passwordView;

- (id)initWithViewModel:(JCPasswordViewModel *)passwordViewModel;

@end
