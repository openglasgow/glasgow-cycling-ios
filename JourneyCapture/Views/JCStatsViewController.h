//
//  JCStatsViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCUserViewModel, JCUserHeaderView;

@interface JCStatsViewController : UIViewController

@property (strong, nonatomic) JCUserViewModel *userViewModel;
@property (strong, nonatomic) JCUserHeaderView *headerView;

- (id)initWithViewModel:(JCUserViewModel *)userViewModel;

@end
