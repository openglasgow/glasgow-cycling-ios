//
//  JCRouteSummaryView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCRouteViewModel;

@interface JCRouteSummaryView : UIView
@property (strong, nonatomic) JCRouteViewModel *viewModel;

@property (strong, nonatomic) UIImageView *safetyView;
@property (strong, nonatomic) UILabel *safetyLabel;
@property (strong, nonatomic) UIImageView *environmentView;
@property (strong, nonatomic) UILabel *environmentLabel;
@property (strong, nonatomic) UIImageView *difficultyView;
@property (strong, nonatomic) UILabel *difficultyLabel;
@property (strong, nonatomic) UIImageView *estimatedTimeView;
@property (strong, nonatomic) UILabel *estimatedTimeLabel;
@property (strong, nonatomic) UIImageView *distanceView;
@property (strong, nonatomic) UILabel *distanceLabel;

- (id)initWithFrame:(CGRect)frame viewModel:(JCRouteViewModel *)userViewModel;
@end
