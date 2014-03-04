//
//  JCUserView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCUserViewModel;

@interface JCUserView : UIView
@property (strong, nonatomic) JCUserViewModel *viewModel;

@property (strong, nonatomic) UILabel *firstNameLabel;
@property (strong, nonatomic) UILabel *lastNameLabel;

@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UIButton *settingsButton;

@property (strong, nonatomic) UIImageView *favouriteRouteView;
@property (strong, nonatomic) UILabel *favouriteRouteLabel;
@property (strong, nonatomic) UIImageView *routesThisMonthView;
@property (strong, nonatomic) UILabel *routesThisMonthLabel;
@property (strong, nonatomic) UIImageView *timeThisMonthView;
@property (strong, nonatomic) UILabel *timeThisMonthLabel;
@property (strong, nonatomic) UIImageView *distanceThisMonthView;
@property (strong, nonatomic) UILabel *distanceThisMonthLabel;

// Stats constraints which need to be updated depending on available data
@property (strong, nonatomic) MASConstraint *favouriteLabelTop;
@property (strong, nonatomic) MASConstraint *favouriteViewTop;
@property (strong, nonatomic) MASConstraint *routesLabelTop;
@property (strong, nonatomic) MASConstraint *routesViewTop;


- (id)initWithFrame:(CGRect)frame viewModel:(JCUserViewModel *)userViewModel;
@end
