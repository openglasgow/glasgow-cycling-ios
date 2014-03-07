//
//  JCUserViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLocationManager.h"
@class JCUserViewModel;

@interface JCUserViewController : UIViewController <JCLocationManagerDelegate>
@property (strong, nonatomic) JCUserViewModel *viewModel;
@property (strong, nonatomic) UIImageView *mapImageView;
@property (strong, nonatomic) UIButton *myRoutesButton;
@property (strong, nonatomic) UIButton *nearbyRoutesButton;
@property (strong, nonatomic) UIButton *createRouteButton;
@end
