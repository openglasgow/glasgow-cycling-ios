//
//  JCUserHeaderView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCUserViewModel;

@interface JCUserHeaderView : UIView
@property (strong, nonatomic) JCUserViewModel *viewModel;

// Profile area
@property (strong, nonatomic) UIView *profileBackgroundView;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *distanceThisMonthLabel;
@property (strong, nonatomic) UILabel *timeThisMonthLabel;
@property (strong, nonatomic) UILabel *hintLabel;

- (id)initWithViewModel:(JCUserViewModel *)userViewModel;
@end
