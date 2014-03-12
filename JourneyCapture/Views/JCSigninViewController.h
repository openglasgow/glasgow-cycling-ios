//
//  JCSigninViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSigninViewModel.h"

@interface JCSigninViewController : UIViewController <UINavigationControllerDelegate>
@property (strong, nonatomic) JCSigninViewModel *viewModel;
@end
