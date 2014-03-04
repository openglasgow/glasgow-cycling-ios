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
@synthesize viewModel;
@synthesize firstNameLabel, lastNameLabel,
        favouriteRouteView, favouriteRouteLabel, routesThisMonthView, routesThisMonthLabel,
        timeThisMonthView, timeThisMonthLabel, distanceThisMonthView, distanceThisMonthLabel,
        routesLabelTop, routesViewTop, favouriteLabelTop, favouriteViewTop;

- (id)initWithFrame:(CGRect)frame viewModel:(JCUserViewModel *)userViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.viewModel = userViewModel;
    [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.85]];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0f;
    int padding = 12;

    // Name
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue"
                                       size:20.0];
    self.firstNameLabel = [[UILabel alloc] init];
    [self.firstNameLabel setFont:nameFont];
    RACChannelTo(self, firstNameLabel.text) = RACChannelTo(self, viewModel.firstName);
    [self addSubview:self.firstNameLabel];

    self.lastNameLabel = [[UILabel alloc] init];
    [self.lastNameLabel setFont:nameFont];
    RACChannelTo(self, lastNameLabel.text) = RACChannelTo(self, viewModel.lastName);
    [self addSubview:self.lastNameLabel];

    [self.firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
    }];

    [self.lastNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstNameLabel.mas_top);
        make.left.equalTo(self.firstNameLabel.mas_right).with.offset(5);
    }];

    // Profile
    UIImage *profileImage = [UIImage imageNamed:@"profile-pic"];
    self.profileImageView = [[UIImageView alloc] initWithImage:profileImage];
    [self addSubview:self.profileImageView];

    [self.profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];

    // Settings
    self.settingsButton = [[UIButton alloc] init];
    UIImage *settingsImage = [UIImage imageNamed:@"gear-button"];
    [self.settingsButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    self.settingsButton.layer.masksToBounds = YES;
    self.settingsButton.layer.cornerRadius = 8.0f;
    [self addSubview:self.settingsButton];

    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImageView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];

    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
    NSNumber *imageSize = @(18);

    // Favourite Routes
    UIImage *favouriteImage = [UIImage imageNamed:@"christmas_star-50"];
    self.favouriteRouteView = [[UIImageView alloc] initWithImage:favouriteImage];
    [self addSubview:self.favouriteRouteView];

    [self.favouriteRouteView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.favouriteViewTop = make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
        make.left.equalTo(self.profileImageView.mas_right).with.offset(padding);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.favouriteRouteLabel = [[UILabel alloc] init];
    [self.favouriteRouteLabel setFont:statsFont];
    [self addSubview:self.favouriteRouteLabel];

    [self.favouriteRouteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.favouriteLabelTop = make.top.equalTo(self.favouriteRouteView.mas_top);
        make.left.equalTo(self.favouriteRouteView.mas_right).with.offset(padding);
    }];

    // Monthly num routes
    UIImage *routesImage = [UIImage imageNamed:@"calendar-50"];
    self.routesThisMonthView = [[UIImageView alloc] initWithImage:routesImage];
    [self addSubview:self.routesThisMonthView];

    [self.routesThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.routesViewTop = make.top.equalTo(self.favouriteRouteView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.routesThisMonthLabel = [[UILabel alloc] init];
    [self.routesThisMonthLabel setFont:statsFont];
    RACChannelTerminal *routesNumLabelChannel = RACChannelTo(self, routesThisMonthLabel.text);
    RACChannelTerminal *routesNumModelChannel = RACChannelTo(self, viewModel.routesThisMonth);
    [[routesNumModelChannel map:^(id numRoutes){
        return [NSString stringWithFormat:@"%@ routes this month", numRoutes];
    }] subscribe:routesNumLabelChannel];
    [self addSubview:self.routesThisMonthLabel];

    [self.routesThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.routesLabelTop = make.top.equalTo(self.routesThisMonthView.mas_top);
        make.left.equalTo(self.favouriteRouteLabel.mas_left);
    }];

    // Monthly time
    UIImage *timeImage = [UIImage imageNamed:@"clock-50"];
    self.timeThisMonthView = [[UIImageView alloc] initWithImage:timeImage];
    [self addSubview:self.timeThisMonthView];

    [self.timeThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.routesThisMonthView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.timeThisMonthLabel = [[UILabel alloc] init];
    [self.timeThisMonthLabel setFont:statsFont];
    RACChannelTerminal *secondsLabelChannel = RACChannelTo(self, timeThisMonthLabel.text);
    RACChannelTerminal *secondsModelChannell = RACChannelTo(self, viewModel.secondsThisMonth);
    [[secondsModelChannell map:^(NSNumber *secondsThisMonth){
        int seconds = [secondsThisMonth intValue];
        int hours = seconds / 3600;
        int minutes = (seconds - (hours * 3600)) / 60;
        return [NSString stringWithFormat:@"%d:%02d hours this month", hours, minutes];
    }] subscribe:secondsLabelChannel];
    [self addSubview:self.timeThisMonthLabel];

    [self.timeThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeThisMonthView.mas_top);
        make.left.equalTo(self.favouriteRouteLabel.mas_left);
    }];

    // Monthly distance
    UIImage *metersImage = [UIImage imageNamed:@"length-50"];
    self.distanceThisMonthView = [[UIImageView alloc] initWithImage:metersImage];
    [self addSubview:self.distanceThisMonthView];

    [self.distanceThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeThisMonthView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.distanceThisMonthLabel = [[UILabel alloc] init];
    [self.distanceThisMonthLabel setFont:statsFont];
    RACChannelTerminal *distanceLabelChannel = RACChannelTo(self, distanceThisMonthLabel.text);
    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.metersThisMonth);
    [[distanceModelChannel map:^(NSNumber *metersThisMonth){
        return [NSString stringWithFormat:@"%@km travelled this month",
                @([metersThisMonth intValue] / 1000)];
    }] subscribe:distanceLabelChannel];
    [self addSubview:self.distanceThisMonthLabel];

    [self.distanceThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceThisMonthView.mas_top);
        make.left.equalTo(self.favouriteRouteLabel.mas_left);
    }];


    // Favourite route text at end - changes positioning of other stats labels
    RACChannelTerminal *favouriteModelChannel = RACChannelTo(self, viewModel.favouriteRouteName);
    [favouriteModelChannel subscribeNext:^(id favouriteRoute) {
        if (favouriteRoute) {
            // Show favourite route info
            [self.favouriteRouteLabel setText:favouriteRoute];
            [self.favouriteRouteLabel setHidden:NO];
            [self.favouriteRouteView setHidden:NO];

            [self.favouriteViewTop uninstall];
            [self.favouriteViewTop uninstall];
            [self.favouriteRouteView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.favouriteViewTop = make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
            }];
            [self.favouriteRouteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.favouriteLabelTop = make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
            }];

            [self.routesViewTop uninstall];
            [self.routesLabelTop uninstall];
            [self.routesThisMonthView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.routesViewTop = make.top.equalTo(self.favouriteRouteView.mas_bottom).with.offset(padding);
            }];
            [self.routesThisMonthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.routesLabelTop = make.top.equalTo(self.favouriteRouteView.mas_bottom).with.offset(padding);
            }];
        } else {
            // Hide favourite route info
            [self.favouriteRouteLabel setHidden:YES];
            [self.favouriteRouteView setHidden:YES];

            [self.routesViewTop uninstall];
            [self.routesLabelTop uninstall];
            [self.routesThisMonthView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.routesViewTop = make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
            }];
            [self.routesThisMonthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                self.routesLabelTop = make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
            }];
        }
    }];

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
