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
    int padding = 12;

    // Name
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue"
                                       size:20.0];
    _firstNameLabel = [[UILabel alloc] init];
    [_firstNameLabel setFont:nameFont];
    RACChannelTo(self, firstNameLabel.text) = RACChannelTo(self, viewModel.firstName);
    [self addSubview:_firstNameLabel];

    _lastNameLabel = [[UILabel alloc] init];
    [_lastNameLabel setFont:nameFont];
    RACChannelTo(self, lastNameLabel.text) = RACChannelTo(self, viewModel.lastName);
    [self addSubview:_lastNameLabel];

    [_firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.height.equalTo(@(25));
    }];

    [_lastNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstNameLabel.mas_top);
        make.left.equalTo(_firstNameLabel.mas_right).with.offset(5);
        make.height.equalTo(@(25));
    }];

    // Profile
    _profileImageView = [[UIImageView alloc] init];
    int profilePicSize = 50;
    RACChannelTo(_profileImageView, image) = RACChannelTo(_viewModel, profilePic);

    // Mask profile pic to hexagon
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"fcd-profile-mask"] CGImage];
    mask.frame = CGRectMake(0, 0, profilePicSize, profilePicSize);
    _profileImageView.layer.mask = mask;
    _profileImageView.layer.masksToBounds = YES;
    [self addSubview:_profileImageView];

    [_profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstNameLabel.mas_bottom).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.height.equalTo(@(profilePicSize));
        make.width.equalTo(@(profilePicSize));
    }];

    // Settings
    _settingsButton = [[UIButton alloc] init];
    UIImage *settingsImage = [UIImage imageNamed:@"gear-button"];
    [_settingsButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [_settingsButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _settingsButton.layer.masksToBounds = YES;
    _settingsButton.layer.cornerRadius = 8.0f;
    [self addSubview:_settingsButton];

    [_settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_profileImageView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];

    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
    NSNumber *imageSize = @(18);

    // Favourite Routes
    UIImage *favouriteImage = [UIImage imageNamed:@"christmas_star-50"];
    _favouriteRouteView = [[UIImageView alloc] initWithImage:favouriteImage];
    [self addSubview:_favouriteRouteView];

    [_favouriteRouteView mas_makeConstraints:^(MASConstraintMaker *make) {
        _favouriteViewTop = make.top.equalTo(_firstNameLabel.mas_bottom).with.offset(padding);
        make.left.equalTo(_profileImageView.mas_right).with.offset(padding);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    _favouriteRouteLabel = [[UILabel alloc] init];
    [_favouriteRouteLabel setFont:statsFont];
    [self addSubview:_favouriteRouteLabel];

    [_favouriteRouteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        _favouriteLabelTop = make.top.equalTo(_favouriteRouteView.mas_top);
        make.left.equalTo(_favouriteRouteView.mas_right).with.offset(padding);
    }];

    // Monthly num routes
    UIImage *routesImage = [UIImage imageNamed:@"calendar-50"];
    _routesThisMonthView = [[UIImageView alloc] initWithImage:routesImage];
    [self addSubview:_routesThisMonthView];

    [_routesThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        _routesViewTop = make.top.equalTo(_favouriteRouteView.mas_bottom).with.offset(padding);
        make.left.equalTo(_favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    _routesThisMonthLabel = [[UILabel alloc] init];
    [_routesThisMonthLabel setFont:statsFont];
    RACChannelTerminal *routesNumLabelChannel = RACChannelTo(self, routesThisMonthLabel.text);
    RACChannelTerminal *routesNumModelChannel = RACChannelTo(self, viewModel.routesThisMonth);
    [[routesNumModelChannel map:^(id numRoutes){
        return [NSString stringWithFormat:@"%@ routes this month", numRoutes ? numRoutes : @"?"];
    }] subscribe:routesNumLabelChannel];
    [self addSubview:_routesThisMonthLabel];

    [_routesThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        _routesLabelTop = make.top.equalTo(_routesThisMonthView.mas_top);
        make.left.equalTo(_favouriteRouteLabel.mas_left);
    }];

    // Monthly time
    UIImage *timeImage = [UIImage imageNamed:@"clock-50"];
    _timeThisMonthView = [[UIImageView alloc] initWithImage:timeImage];
    [self addSubview:_timeThisMonthView];

    [_timeThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_routesThisMonthView.mas_bottom).with.offset(padding);
        make.left.equalTo(_favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    _timeThisMonthLabel = [[UILabel alloc] init];
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

    [_timeThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeThisMonthView.mas_top);
        make.left.equalTo(_favouriteRouteLabel.mas_left);
    }];

    // Monthly distance
    UIImage *metersImage = [UIImage imageNamed:@"length-50"];
    _distanceThisMonthView = [[UIImageView alloc] initWithImage:metersImage];
    [self addSubview:_distanceThisMonthView];

    [_distanceThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeThisMonthView.mas_bottom).with.offset(padding);
        make.left.equalTo(_favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    _distanceThisMonthLabel = [[UILabel alloc] init];
    [_distanceThisMonthLabel setFont:statsFont];
    RACChannelTerminal *distanceLabelChannel = RACChannelTo(self, distanceThisMonthLabel.text);
    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.kmThisMonth);
    [[distanceModelChannel map:^(NSNumber *kmThisMonth){
        return [NSString stringWithFormat:@"%.02f km this month", [kmThisMonth doubleValue]];
    }] subscribe:distanceLabelChannel];
    [self addSubview:_distanceThisMonthLabel];

    [_distanceThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_distanceThisMonthView.mas_top);
        make.left.equalTo(_favouriteRouteLabel.mas_left);
    }];


    // Favourite route text - changes positioning of other stats labels
    RACChannelTerminal *favouriteModelChannel = RACChannelTo(self, viewModel.favouriteRouteName);
    [favouriteModelChannel subscribeNext:^(id favouriteRoute) {
        if (favouriteRoute) {
            // Show favourite route info
            [_favouriteRouteLabel setText:favouriteRoute];
            [_favouriteRouteLabel setHidden:NO];
            [_favouriteRouteView setHidden:NO];

            [_favouriteViewTop uninstall];
            [_favouriteViewTop uninstall];
            [_favouriteRouteView mas_updateConstraints:^(MASConstraintMaker *make) {
                _favouriteViewTop = make.top.equalTo(_firstNameLabel.mas_bottom).with.offset(padding);
            }];
            [_favouriteRouteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                _favouriteLabelTop = make.top.equalTo(_firstNameLabel.mas_bottom).with.offset(padding);
            }];

            [_routesViewTop uninstall];
            [_routesLabelTop uninstall];
            [_routesThisMonthView mas_updateConstraints:^(MASConstraintMaker *make) {
                _routesViewTop = make.top.equalTo(_favouriteRouteView.mas_bottom).with.offset(padding);
            }];
            [_routesThisMonthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                _routesLabelTop = make.top.equalTo(_favouriteRouteView.mas_bottom).with.offset(padding);
            }];
        } else {
            // Hide favourite route info
            [_favouriteRouteLabel setHidden:YES];
            [_favouriteRouteView setHidden:YES];

            [_routesViewTop uninstall];
            [_routesLabelTop uninstall];
            [_routesThisMonthView mas_updateConstraints:^(MASConstraintMaker *make) {
                _routesViewTop = make.top.equalTo(_firstNameLabel.mas_bottom).with.offset(padding);
            }];
            [_routesThisMonthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                _routesLabelTop = make.top.equalTo(_firstNameLabel.mas_bottom).with.offset(padding);
            }];
        }
    }];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{

    [super layoutSubviews];
}

@end
