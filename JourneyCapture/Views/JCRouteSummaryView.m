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

@implementation JCRouteSummaryView
@synthesize viewModel, safetyLabel, safetyView, environmentLabel, environmentView,
        difficultyLabel, difficultyView, estimatedTimeLabel, estimatedTimeView,
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
    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.distanceMetres);
    [[distanceModelChannel map:^(id meters){
        float km = [meters intValue]/1000.0;
        return [NSString stringWithFormat:@"%.02f km", km];
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

    self.safetyLabel = [[UILabel alloc] init];
    [self.safetyLabel setFont:statsFont];
    RACChannelTerminal *safetyRatingLabelChannel = RACChannelTo(self, safetyLabel.text);
    RACChannelTerminal *safetyRatingModelChannel = RACChannelTo(self, viewModel.safetyRating);
    [[safetyRatingModelChannel map:^(id avgRating){
        return [NSString stringWithFormat:@"%@ stars", avgRating];
    }] subscribe:safetyRatingLabelChannel];
    [self addSubview:self.safetyLabel];

    [self.safetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyView.mas_top);
        make.left.equalTo(self.estimatedTimeLabel.mas_left);
    }];

    // Difficulty
    UIImage *difficultyImage = [UIImage imageNamed:@"lock-50"];
    self.difficultyView = [[UIImageView alloc] initWithImage:difficultyImage];
    [self addSubview:self.difficultyView];

    [self.difficultyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.estimatedTimeView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.difficultyLabel = [[UILabel alloc] init];
    [self.difficultyLabel setFont:statsFont];
    RACChannelTerminal *difficultyRatingLabelChannel = RACChannelTo(self, difficultyLabel.text);
    RACChannelTerminal *difficultyRatingModelChannel = RACChannelTo(self, viewModel.difficultyRating);
    [[difficultyRatingModelChannel map:^(id avgRating){
        return [NSString stringWithFormat:@"%@ stars", avgRating];
    }] subscribe:difficultyRatingLabelChannel];
    [self addSubview:self.difficultyLabel];

    [self.difficultyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.difficultyView.mas_top);
        make.left.equalTo(self.estimatedTimeLabel.mas_left);
    }];

    // Environment
    UIImage *environmentImage = [UIImage imageNamed:@"lock-50"];
    self.environmentView = [[UIImageView alloc] initWithImage:environmentImage];
    [self addSubview:self.environmentView];

    [self.environmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.difficultyView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.estimatedTimeView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    self.environmentLabel = [[UILabel alloc] init];
    [self.environmentLabel setFont:statsFont];
    RACChannelTerminal *environmentRatingLabelChannel = RACChannelTo(self, environmentLabel.text);
    RACChannelTerminal *environmentRatingModelChannel = RACChannelTo(self, viewModel.environmentRating);
    [[environmentRatingModelChannel map:^(id avgRating){
        return [NSString stringWithFormat:@"%@ stars", avgRating];
    }] subscribe:environmentRatingLabelChannel];
    [self addSubview:self.environmentLabel];

    [self.environmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.environmentView.mas_top);
        make.left.equalTo(self.estimatedTimeLabel.mas_left);
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
