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
@synthesize viewModel;

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
    
    self.nameLabel = [[UILabel alloc] init];
    [self.nameLabel setText:self.viewModel.name];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];

    // Stats images
    UIImage *safetyImage = [UIImage imageNamed:@"lock-50"];
    self.safetyView = [[UIImageView alloc] initWithImage:safetyImage];
    [self addSubview:self.safetyView];
    
    UIImage *lastUsedImage = [UIImage imageNamed:@"calendar-50"];
    self.lastUsedView = [[UIImageView alloc] initWithImage:lastUsedImage];
    [self addSubview:self.lastUsedView];
    
    UIImage *estimatedTimeImage = [UIImage imageNamed:@"clock-50"];
    self.estimatedTimeView = [[UIImageView alloc] initWithImage:estimatedTimeImage];
    [self addSubview:self.estimatedTimeView];
    
    UIImage *distanceImage = [UIImage imageNamed:@"length-50"];
    self.distanceView = [[UIImageView alloc] initWithImage:distanceImage];
    [self addSubview:self.distanceView];
    
    int padding = 12;
    NSNumber *imageSize = @(18);
    [self.safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];
    
    [self.lastUsedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.safetyView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];
    
    [self.estimatedTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastUsedView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.safetyView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];
    
    [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.safetyView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];
    
    // Stats text
    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue"
                                        size:12.0];
    
    self.safetyLabel = [[UILabel alloc] init];
    [self.safetyLabel setFont:statsFont];
    [self.safetyLabel setText:self.viewModel.safetyRating];
    [self addSubview:self.safetyLabel];
    
    self.lastUsedLabel = [[UILabel alloc] init];
    [self.lastUsedLabel setFont:statsFont];
    [self.lastUsedLabel setText:self.viewModel.lastUsed];
    [self addSubview:self.lastUsedLabel];
    
    self.estimatedTimeLabel = [[UILabel alloc] init];
    [self.estimatedTimeLabel setFont:statsFont];
    [self.estimatedTimeLabel setText:self.viewModel.estimatedTime];
    [self addSubview:self.estimatedTimeLabel];
    
    self.distanceLabel = [[UILabel alloc] init];
    [self.distanceLabel setFont:statsFont];
    [self.distanceLabel setText:self.viewModel.distanceKm];
    [self addSubview:self.distanceLabel];
    
    // Positioning
    [self.safetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyView.mas_top);
        make.left.equalTo(self.safetyView.mas_right).with.offset(padding);
    }];
    
    [self.lastUsedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastUsedView.mas_top);
        make.left.equalTo(self.safetyLabel.mas_left);
    }];
    
    [self.estimatedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_top);
        make.left.equalTo(self.safetyLabel.mas_left);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceView.mas_top);
        make.left.equalTo(self.safetyLabel.mas_left);
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
