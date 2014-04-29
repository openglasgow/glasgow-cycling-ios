//
//  JCUserViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLocationManager.h"
@class JCUserViewModel, JCUserView;

@interface JCUserViewController : UIViewController <JCLocationManagerDelegate,
    UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) JCUserViewModel *viewModel;
@property (strong, nonatomic) JCUserView *userView;
@property (readwrite, nonatomic) BOOL updateOnAppear;

- (void)update;
@end
