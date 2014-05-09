//
//  JCCaptureStatsView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 30/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCaptureStatsView.h"
#import "JCCaptureViewModel.h"
#import "JCRoutePointViewModel.h"

@implementation JCCaptureStatsView

- (id)initWithViewModel:(JCCaptureViewModel *)captureViewModel
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _viewModel = captureViewModel;
    
    // Stats
    UIFont *statsTitleFont = [UIFont systemFontOfSize:12];
    UIColor *statsTitleColor = [UIColor jc_lightBlueColor];
    UIFont *statsFont = [UIFont boldSystemFontOfSize:24];
    UIColor *statsColor = [UIColor jc_blueColor];//[UIColor colorWithRed:127/255.0f green:106/255.0f blue:106/255.0f alpha:1.0];
    
    // Current speed
    _currentSpeedLabel = [UILabel new];
    _currentSpeedLabel.font = statsFont;
    _currentSpeedLabel.textColor = statsColor;
    _currentSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _currentSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _currentSpeedLabel.text = @"0.0 mph";
    
    [RACObserve(_viewModel, currentSpeed) subscribeNext:^(id speedMps) {
        double currentSpeedKph = ([speedMps doubleValue] * 60 * 60) / 1000;
        double currentSpeedMph = currentSpeedKph* 0.621371192f;
        NSString *currentSpeedText = [NSString stringWithFormat:@"%.01f mph", currentSpeedMph];
        _currentSpeedLabel.text = currentSpeedText;
    }];
    
    [self addSubview:_currentSpeedLabel];
    
    _currentSpeedTitleLabel = [UILabel new];
    _currentSpeedTitleLabel.font = statsTitleFont;
    _currentSpeedTitleLabel.textColor = statsTitleColor;
    _currentSpeedTitleLabel.text = @"Speed";
    _currentSpeedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_currentSpeedTitleLabel];
    
    // Average speed
    _averageSpeedLabel = [UILabel new];
    _averageSpeedLabel.font = statsFont;
    _averageSpeedLabel.textColor = statsColor;
    _averageSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _averageSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _averageSpeedLabel.text = @"0.0 mph";
    
    [RACObserve(_viewModel, averageSpeed) subscribeNext:^(id speedMps) {
        double averageSpeedKph = ([speedMps doubleValue] * 60 * 60) / 1000;
        double averageSpeedMph = averageSpeedKph* 0.621371192f;
        NSString *averageSpeedText = [NSString stringWithFormat:@"%.01f mph", averageSpeedMph];
        _averageSpeedLabel.text = averageSpeedText;
    }];
    
    [self addSubview:_averageSpeedLabel];
    
    _averageSpeedTitleLabel = [UILabel new];
    _averageSpeedTitleLabel.font = statsTitleFont;
    _averageSpeedTitleLabel.textColor = statsTitleColor;
    _averageSpeedTitleLabel.text = @"Average Speed";
    _averageSpeedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_averageSpeedTitleLabel];
    
    // Total time
    _totalTimeLabel = [UILabel new];
    _totalTimeLabel.font = statsFont;
    _totalTimeLabel.textColor = statsColor;
    _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    _totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalTimeLabel.text = @"00:00";
    
    _timer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    [self addSubview:_totalTimeLabel];
    
    _totalTimeTitleLabel = [UILabel new];
    _totalTimeTitleLabel.font = statsTitleFont;
    _totalTimeTitleLabel.textColor = statsTitleColor;
    _totalTimeTitleLabel.text = @"Total Time";
    _totalTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_totalTimeTitleLabel];
    
    // Total distance
    _totalDistanceLabel = [UILabel new];
    _totalDistanceLabel.font = statsFont;
    _totalDistanceLabel.textColor = statsColor;
    _totalDistanceLabel.textAlignment = NSTextAlignmentCenter;
    _totalDistanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalDistanceLabel.text = @"0.0 mi";
    
    [RACObserve(_viewModel, totalKm) subscribeNext:^(id totalDistanceKm) {
        double distanceKm = [totalDistanceKm doubleValue];
        double distanceMiles = distanceKm * 0.621371192f;
        NSString *distanceText = [NSString stringWithFormat:@"%.01f mi", distanceMiles];
        _totalDistanceLabel.text = distanceText;
    }];
    
    [self addSubview:_totalDistanceLabel];
    
    _totalDistanceTitleLabel = [UILabel new];
    _totalDistanceTitleLabel.font = statsTitleFont;
    _totalDistanceTitleLabel.textColor = statsTitleColor;
    _totalDistanceTitleLabel.text = @"Total Distance";
    _totalDistanceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_totalDistanceTitleLabel];
    
    return self;
}

- (void)updateTime
{
    JCRoutePointViewModel *firstPoint = [_viewModel.points firstObject];
    NSTimeInterval totalSeconds = 0;
    if (firstPoint) {
        CLLocation *firstLocation = [firstPoint location];
        NSDate *startTime = [firstLocation timestamp];
        NSDate *now = [NSDate date];
        totalSeconds = [now timeIntervalSinceDate:startTime];
    }
    
    int hours = totalSeconds / 3600;
    int minutes = (totalSeconds - (hours * 3600)) / 60;
    int seconds = totalSeconds - (minutes * 60);
    NSString *shortTime = @"";
    if (hours == 0) {
        shortTime = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    } else {
        shortTime = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    
    _totalTimeLabel.text = shortTime;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    // Stats are in four quadrants
    
    // Current speed - top left
    [_currentSpeedLabel autoRemoveConstraintsAffectingView];
    [_currentSpeedLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
    [_currentSpeedLabel autoConstrainAttribute:ALEdgeRight toAttribute:ALAxisVertical ofView:self withOffset:-15];
    [_currentSpeedLabel autoConstrainAttribute:ALEdgeBottom toAttribute:ALAxisHorizontal ofView:self withOffset:-15];
    
    [_currentSpeedTitleLabel autoRemoveConstraintsAffectingView];
    [_currentSpeedTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_currentSpeedLabel];
    [_currentSpeedTitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_currentSpeedLabel];
    [_currentSpeedTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_currentSpeedLabel];
    
    // Average speed - top right
    [_averageSpeedLabel autoRemoveConstraintsAffectingView];
    [_averageSpeedLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15];
    [_averageSpeedLabel autoConstrainAttribute:ALEdgeLeft toAttribute:ALAxisVertical ofView:self withOffset:15];
    [_averageSpeedLabel autoConstrainAttribute:ALEdgeBottom toAttribute:ALAxisHorizontal ofView:self withOffset:-15];
    
    [_averageSpeedTitleLabel autoRemoveConstraintsAffectingView];
    [_averageSpeedTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_averageSpeedLabel];
    [_averageSpeedTitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_averageSpeedLabel];
    [_averageSpeedTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_averageSpeedLabel];
    
    // Total time - bottom left
    [_totalTimeLabel autoRemoveConstraintsAffectingView];
    [_totalTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
    [_totalTimeLabel autoConstrainAttribute:ALEdgeRight toAttribute:ALAxisVertical ofView:self withOffset:-15];
    [_totalTimeLabel autoConstrainAttribute:ALEdgeTop toAttribute:ALAxisHorizontal ofView:self withOffset:15];
    
    [_totalTimeTitleLabel autoRemoveConstraintsAffectingView];
    [_totalTimeTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_totalTimeLabel];
    [_totalTimeTitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_totalTimeLabel];
    [_totalTimeTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_totalTimeLabel];
    
    // Total distance - bottom right
    [_totalDistanceLabel autoRemoveConstraintsAffectingView];
    [_totalDistanceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15];
    [_totalDistanceLabel autoConstrainAttribute:ALEdgeLeft toAttribute:ALAxisVertical ofView:self withOffset:15];
    [_totalDistanceLabel autoConstrainAttribute:ALEdgeTop toAttribute:ALAxisHorizontal ofView:self withOffset:15];
    
    [_totalDistanceTitleLabel autoRemoveConstraintsAffectingView];
    [_totalDistanceTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_totalDistanceLabel];
    [_totalDistanceTitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_totalDistanceLabel];
    [_totalDistanceTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_totalDistanceLabel];
    
    [super layoutSubviews];
}

@end
