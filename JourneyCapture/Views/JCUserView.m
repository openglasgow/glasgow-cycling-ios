//
//  JCUserView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserView.h"
#import "JCUserViewModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation JCUserView

- (id)initWithViewModel:(JCUserViewModel *)userViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = userViewModel;
    [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.85]];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0f;

    // Name
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue" size:20.0];
    _firstNameLabel = [UILabel new];
    _firstNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_firstNameLabel setFont:nameFont];
    RACChannelTo(self, firstNameLabel.text) = RACChannelTo(self, viewModel.firstName);
    [self addSubview:_firstNameLabel];

    _lastNameLabel = [UILabel new];
    _lastNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_lastNameLabel setFont:nameFont];
    RACChannelTo(self, lastNameLabel.text) = RACChannelTo(self, viewModel.lastName);
    [self addSubview:_lastNameLabel];

    // Profile
    _profileImageView = [UIImageView new];
    _profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    RACChannelTo(_profileImageView, image) = RACChannelTo(_viewModel, profilePic);

    // Mask profile pic to hexagon
    CALayer *mask = [CALayer layer];
    int profilePicSize = 50;
    mask.contents = (id)[[UIImage imageNamed:@"fcd-profile-mask"] CGImage];
    mask.frame = CGRectMake(0, 0, profilePicSize, profilePicSize);
    _profileImageView.layer.mask = mask;
    _profileImageView.layer.masksToBounds = YES;
    [self addSubview:_profileImageView];

    // Settings
    _settingsButton = [UIButton new];
    UIImage *settingsImage = [UIImage imageNamed:@"gear-button"];
    [_settingsButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [_settingsButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _settingsButton.layer.masksToBounds = YES;
    _settingsButton.layer.cornerRadius = 8.0f;
    _settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_settingsButton];

    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue" size:12.0];

    // Monthly num routes
    UIImage *routesImage = [UIImage imageNamed:@"calendar-50"];
    _routesThisMonthView = [[UIImageView alloc] initWithImage:routesImage];
    _routesThisMonthView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_routesThisMonthView];

    _routesThisMonthLabel = [UILabel new];
    _routesThisMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_routesThisMonthLabel setFont:statsFont];
    RACChannelTerminal *routesNumLabelChannel = RACChannelTo(self, routesThisMonthLabel.text);
    RACChannelTerminal *routesNumModelChannel = RACChannelTo(self, viewModel.routesThisMonth);
    [[routesNumModelChannel map:^(id numRoutes){
        return [NSString stringWithFormat:@"%@ routes this month", numRoutes ? numRoutes : @"?"];
    }] subscribe:routesNumLabelChannel];
    [self addSubview:_routesThisMonthLabel];

    // Monthly time
    UIImage *timeImage = [UIImage imageNamed:@"clock-50"];
    _timeThisMonthView = [[UIImageView alloc] initWithImage:timeImage];
    _timeThisMonthView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_timeThisMonthView];

    _timeThisMonthLabel = [UILabel new];
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
    UIImage *metersImage = [UIImage imageNamed:@"length-50"];
    _distanceThisMonthView = [[UIImageView alloc] initWithImage:metersImage];
    _distanceThisMonthView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_distanceThisMonthView];

    _distanceThisMonthLabel = [UILabel new];
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
    int padding = 12;
    int profilePicSize = 50;
    int imageSize = 18;

    [_firstNameLabel autoRemoveConstraintsAffectingView];
    [_firstNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:padding];
    [_firstNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_firstNameLabel autoSetDimension:ALDimensionHeight toSize:25];

    [_lastNameLabel autoRemoveConstraintsAffectingView];
    [_lastNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_firstNameLabel];
    [_lastNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_firstNameLabel withOffset:5];
    [_lastNameLabel autoSetDimension:ALDimensionHeight toSize:25];

    [_profileImageView autoRemoveConstraintsAffectingView];
    [_profileImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_firstNameLabel withOffset:padding];
    [_profileImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_profileImageView autoSetDimensionsToSize:CGSizeMake(profilePicSize, profilePicSize)];

    [_settingsButton autoRemoveConstraintsAffectingView];
    [_settingsButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_profileImageView withOffset:padding];
    [_settingsButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:padding];
    [_settingsButton autoSetDimensionsToSize:CGSizeMake(50, 50)];

    [_routesThisMonthView autoRemoveConstraintsAffectingView];
    [_routesThisMonthView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_profileImageView withOffset:padding];
    [_routesThisMonthView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_firstNameLabel withOffset:padding];
    [_routesThisMonthView autoSetDimensionsToSize:CGSizeMake(imageSize, imageSize)];

    [_timeThisMonthView autoRemoveConstraintsAffectingView];
    [_timeThisMonthView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_routesThisMonthView withOffset:padding];
    [_timeThisMonthView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_routesThisMonthView];
    [_timeThisMonthView autoSetDimensionsToSize:CGSizeMake(imageSize, imageSize)];

    [_distanceThisMonthView autoRemoveConstraintsAffectingView];
    [_distanceThisMonthView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_timeThisMonthView withOffset:padding];
    [_distanceThisMonthView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_routesThisMonthView];
    [_distanceThisMonthView autoSetDimensionsToSize:CGSizeMake(imageSize, imageSize)];

    [_distanceThisMonthLabel autoRemoveConstraintsAffectingView];
    [_distanceThisMonthLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_distanceThisMonthView];
    [_distanceThisMonthLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_distanceThisMonthView withOffset:padding];

    [_routesThisMonthLabel autoRemoveConstraintsAffectingView];
    [_routesThisMonthLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_routesThisMonthView];
    [_routesThisMonthLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_distanceThisMonthLabel];

    [_timeThisMonthLabel autoRemoveConstraintsAffectingView];
    [_timeThisMonthLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_timeThisMonthView];
    [_timeThisMonthLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_distanceThisMonthLabel];

    [super layoutSubviews];
}

@end
