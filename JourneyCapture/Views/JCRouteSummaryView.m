//
//  JCRouteSummaryView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteSummaryView.h"
#import "JCRouteViewModel.h"
#import <QuartzCore/QuartzCore.h>
#import <EDStarRating/EDStarRating.h>

@implementation JCRouteSummaryView
@synthesize viewModel, safetyView, safetyStarRating, environmentStarRating, environmentView,
        difficultyStarRating, difficultyView, estimatedTimeLabel, estimatedTimeView,
        distanceLabel, distanceView;

- (id)initWithFrame:(CGRect)frame viewModel:(JCRouteViewModel *)userViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    self.viewModel = userViewModel;

    [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0f;

    int padding = 12;
    NSNumber *imageSize = @18;
    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue"
                                        size:12.0];

    // Time
    UIImage *estimatedTimeImage = [UIImage imageNamed:@"clock-50"];
    self.estimatedTimeView = [[UIImageView alloc] initWithImage:estimatedTimeImage];
    [self addSubview:self.estimatedTimeView];

    [self.estimatedTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.estimatedTimeLabel = [[UILabel alloc] init];
    [self.estimatedTimeLabel setFont:statsFont];
    RACChannelTerminal *estimatedTimeLabelChannel = RACChannelTo(self, estimatedTimeLabel.text);
    RACChannelTerminal *estimatedTimeModelChannel = RACChannelTo(self, viewModel.estimatedTime);
    [[estimatedTimeModelChannel map:^(id estSeconds){
        return [self.viewModel readableTime];
    }] subscribe:estimatedTimeLabelChannel];
    [self addSubview:self.estimatedTimeLabel];

    [self.estimatedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_top);
        make.left.equalTo(self.estimatedTimeView.mas_right).with.offset(padding);
    }];

    // Distance
    UIImage *distanceImage = [UIImage imageNamed:@"length-50"];
    self.distanceView = [[UIImageView alloc] initWithImage:distanceImage];
    [self addSubview:self.distanceView];

    [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.estimatedTimeView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.distanceLabel = [[UILabel alloc] init];
    [self.distanceLabel setFont:statsFont];
    RACChannelTerminal *distanceLabelChannel = RACChannelTo(self, distanceLabel.text);
    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.totalKm);
    [[distanceModelChannel map:^(id km){
        return [NSString stringWithFormat:@"%.02f km", [km doubleValue]];
    }] subscribe:distanceLabelChannel];
    [self addSubview:self.distanceLabel];

    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceView.mas_top);
        make.left.equalTo(self.estimatedTimeLabel.mas_left);
    }];

    // Safety
    UIImage *safetyImage = [UIImage imageNamed:@"lock-50"];
    self.safetyView = [[UIImageView alloc] initWithImage:safetyImage];
    [self addSubview:self.safetyView];

    [self.safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.estimatedTimeView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.safetyStarRating = [[EDStarRating alloc] init];
    [self.safetyStarRating setEditable:NO];
    [self.safetyStarRating setDisplayMode:EDStarRatingDisplayFull];
    self.safetyStarRating.rating = self.viewModel.safetyRating;
    self.safetyStarRating.starImage = [UIImage imageNamed:@"star-template"];
    self.safetyStarRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [self.safetyStarRating setBackgroundColor:[UIColor clearColor]];
    self.safetyStarRating.horizontalMargin = 5;
    RACChannelTo(self.safetyStarRating, rating) = RACChannelTo(self.viewModel, safetyRating);
    [self addSubview:self.safetyStarRating];

    [self.safetyStarRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyView.mas_top);
        make.left.equalTo(self.estimatedTimeLabel.mas_left);
        make.width.equalTo(@120);
        make.height.equalTo(@16);
    }];

    // Difficulty
    UIImage *difficultyImage = [UIImage imageNamed:@"polyline-50"];
    self.difficultyView = [[UIImageView alloc] initWithImage:difficultyImage];
    [self addSubview:self.difficultyView];

    [self.difficultyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.estimatedTimeView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.difficultyStarRating = [[EDStarRating alloc] init];
    [self.difficultyStarRating setEditable:NO];
    [self.difficultyStarRating setDisplayMode:EDStarRatingDisplayFull];
    self.difficultyStarRating.rating = self.viewModel.difficultyRating;
    self.difficultyStarRating.starImage = [UIImage imageNamed:@"star-template"];
    self.difficultyStarRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [self.difficultyStarRating setBackgroundColor:[UIColor clearColor]];
    self.difficultyStarRating.horizontalMargin = 5;
    RACChannelTo(self.difficultyStarRating, rating) = RACChannelTo(self.viewModel, difficultyRating);
    [self addSubview:self.difficultyStarRating];

    [self.difficultyStarRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.difficultyView.mas_top);
        make.left.equalTo(self.estimatedTimeLabel.mas_left);
        make.width.equalTo(@120);
        make.height.equalTo(@16);
    }];

    // Environment
    UIImage *environmentImage = [UIImage imageNamed:@"tree-50"];
    self.environmentView = [[UIImageView alloc] initWithImage:environmentImage];
    [self addSubview:self.environmentView];

    [self.environmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.difficultyView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.estimatedTimeView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.environmentStarRating = [[EDStarRating alloc] init];
    [self.environmentStarRating setEditable:NO];
    [self.environmentStarRating setDisplayMode:EDStarRatingDisplayFull];
    self.environmentStarRating.rating = self.viewModel.environmentRating;
    self.environmentStarRating.starImage = [UIImage imageNamed:@"star-template"];
    self.environmentStarRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [self.environmentStarRating setBackgroundColor:[UIColor clearColor]];
    self.environmentStarRating.horizontalMargin = 5;
    RACChannelTo(self.environmentStarRating, rating) = RACChannelTo(self.viewModel, environmentRating);
    [self addSubview:self.environmentStarRating];

    [self.environmentStarRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.environmentView.mas_top);
        make.left.equalTo(self.estimatedTimeLabel.mas_left);
        make.width.equalTo(@120);
        make.height.equalTo(@16);
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
