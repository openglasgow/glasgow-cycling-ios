//
//  JCUserHeaderView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserHeaderView.h"
#import "JCUserViewModel.h"

@implementation JCUserHeaderView

- (id)initWithViewModel:(JCUserViewModel *)userViewModel
{
    self = [super init];
    if (! self) {
        return self;
    }
    
    _viewModel = userViewModel;
    
    // Profile
    _profileBackgroundView = [UIView new];
    _profileBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _profileBackgroundView.backgroundColor = [UIColor jc_blueColor];
    [self addSubview:_profileBackgroundView];
    
    _profileImageView = [UIImageView new];
    _profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    RACChannelTo(_profileImageView, image) = RACChannelTo(_viewModel, profilePic);
    
    // Mask profile pic
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.cornerRadius = 56.0f;
    _profileImageView.layer.borderWidth = 4.0f;
    _profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_profileImageView];
    
    // Profile stats
    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
    
    // Monthly time
    _timeThisMonthLabel = [UILabel new];
    _timeThisMonthLabel.textColor = [UIColor whiteColor];
    _timeThisMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_timeThisMonthLabel setFont:statsFont];
    RACChannelTerminal *secondsLabelChannel = RACChannelTo(self, timeThisMonthLabel.text);
    RACChannelTerminal *secondsModelChannell = RACChannelTo(self, viewModel.secondsThisMonth);
    [[secondsModelChannell map:^(NSNumber *secondsThisMonth){
        int seconds = [secondsThisMonth intValue];
        int hours = seconds / 3600;
        int minutes = (seconds - (hours * 3600)) / 60;
        return [NSString stringWithFormat:@"%d:%02d hours this month", hours, minutes];
    }] subscribe:secondsLabelChannel];
    [self addSubview:_timeThisMonthLabel];
    
    // Monthly distance
    _distanceThisMonthLabel = [UILabel new];
    _distanceThisMonthLabel.textColor = [UIColor whiteColor];
    _distanceThisMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_distanceThisMonthLabel setFont:statsFont];
    RACChannelTerminal *distanceLabelChannel = RACChannelTo(self, distanceThisMonthLabel.text);
    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.kmThisMonth);
    [[distanceModelChannel map:^(NSNumber *kmThisMonth){
        return [NSString stringWithFormat:@"%.02f km this month", [kmThisMonth doubleValue]];
    }] subscribe:distanceLabelChannel];
    [self addSubview:_distanceThisMonthLabel];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    // Profile
    [_profileBackgroundView autoRemoveConstraintsAffectingView];
    [_profileBackgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [_profileImageView autoRemoveConstraintsAffectingView];
    [_profileImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:28];
    [_profileImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_profileImageView autoSetDimensionsToSize:CGSizeMake(112, 112)];
    
    [_distanceThisMonthLabel autoRemoveConstraintsAffectingView];
    [_distanceThisMonthLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_profileImageView withOffset:5];
    [_distanceThisMonthLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_timeThisMonthLabel autoRemoveConstraintsAffectingView];
    [_timeThisMonthLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_distanceThisMonthLabel withOffset:5];
    [_timeThisMonthLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [super layoutSubviews];
}

@end
