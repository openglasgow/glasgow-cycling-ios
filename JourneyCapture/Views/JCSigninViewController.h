//
//  JCSigninViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCSigninViewModel, JCSigninView;

@interface JCSigninViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) JCSigninViewModel *viewModel;
@property (strong, nonatomic) JCSigninView *signinView;
@end
