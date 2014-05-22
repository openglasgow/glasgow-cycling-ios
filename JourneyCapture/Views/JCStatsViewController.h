//
//  JCStatsViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCUserViewModel, JCUserHeaderView, JCGraphScrollView, JCUsageViewModel;

@interface JCStatsViewController : UIViewController

@property (strong, nonatomic) JCUserViewModel *userViewModel;
@property (strong, nonatomic) JCUsageViewModel *usageViewModel;
@property (strong, nonatomic) JCUserHeaderView *headerView;
@property (strong, nonatomic) UILabel *hintLabel;
@property (strong, nonatomic) JCGraphScrollView *graphScrollView;

- (id)initWithViewModel:(JCUserViewModel *)userViewModel;

@end
