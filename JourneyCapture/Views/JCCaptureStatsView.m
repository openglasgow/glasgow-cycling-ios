//
//  JCCaptureStatsView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 30/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCaptureStatsView.h"
#import "JCRouteViewModel.h"

@implementation JCCaptureStatsView

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _viewModel = routeViewModel;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"stats-background"];
    _backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_backgroundImageView];
    
    // Stats
    UIFont *statsFont = [UIFont systemFontOfSize:24];
    
    _currentSpeedLabel = [UILabel new];
    _currentSpeedLabel.font = statsFont;
    _currentSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _currentSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_currentSpeedLabel];
    
    [RACChannelTo(_viewModel, currentSpeed) subscribeNext:^(id speedKph) {
        double currentSpeedKph = [speedKph doubleValue];
        double currentSpeedMph = currentSpeedKph * 0.621371192f;
        NSString *currentSpeedText = [NSString stringWithFormat:@"%.02f mph", currentSpeedMph];
        _currentSpeedLabel.text = currentSpeedText;
    }];
    
    _averageSpeedLabel = [UILabel new];
    _averageSpeedLabel.font = statsFont;
    _averageSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _averageSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_averageSpeedLabel setText:@"avg 26 mph"];
    [self addSubview:_averageSpeedLabel];
    
    _totalTimeLabel = [UILabel new];
    _totalTimeLabel.font = statsFont;
    _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    _totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_totalTimeLabel setText:@"3:15.30"];
    [self addSubview:_totalTimeLabel];
    
    _totalDistanceLabel = [UILabel new];
    _totalDistanceLabel.font = statsFont;
    _totalDistanceLabel.textAlignment = NSTextAlignmentCenter;
    _totalDistanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_totalDistanceLabel setText:@"34.5 miles"];
    [self addSubview:_totalDistanceLabel];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_backgroundImageView autoRemoveConstraintsAffectingView];
    [_backgroundImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50, 30, 50, 30)];
    
    // Top left, top right, bot left, bot right
    
    [_currentSpeedLabel autoRemoveConstraintsAffectingView];
    [_currentSpeedLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15];
    [_currentSpeedLabel autoConstrainAttribute:ALEdgeRight toAttribute:ALAxisVertical ofView:self withOffset:-14.9];
    [_currentSpeedLabel autoConstrainAttribute:ALEdgeBottom toAttribute:ALAxisHorizontal ofView:self withOffset:-14.9];
    
    [_averageSpeedLabel autoRemoveConstraintsAffectingView];
    [_averageSpeedLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15];
    [_averageSpeedLabel autoConstrainAttribute:ALEdgeLeft toAttribute:ALAxisVertical ofView:self withOffset:14.9];
    [_averageSpeedLabel autoConstrainAttribute:ALEdgeBottom toAttribute:ALAxisHorizontal ofView:self withOffset:-14.9];
    
    [_totalTimeLabel autoRemoveConstraintsAffectingView];
    [_totalTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15];
    [_totalTimeLabel autoConstrainAttribute:ALEdgeRight toAttribute:ALAxisVertical ofView:self withOffset:-14.9];
    [_totalTimeLabel autoConstrainAttribute:ALEdgeTop toAttribute:ALAxisHorizontal ofView:self withOffset:14.9];
    
    [_totalDistanceLabel autoRemoveConstraintsAffectingView];
    [_totalDistanceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15];
    [_totalDistanceLabel autoConstrainAttribute:ALEdgeLeft toAttribute:ALAxisVertical ofView:self withOffset:14.9];
    [_totalDistanceLabel autoConstrainAttribute:ALEdgeTop toAttribute:ALAxisHorizontal ofView:self withOffset:14.9];
    
    [super layoutSubviews];
}

@end
