//
//  JCCaptureStatsView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 30/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCCaptureViewModel;

@interface JCCaptureStatsView : UIView
@property (strong, nonatomic) JCCaptureViewModel *viewModel;

@property (strong, nonatomic) UILabel *currentSpeedTitleLabel;
@property (strong, nonatomic) UILabel *averageSpeedTitleLabel;
@property (strong, nonatomic) UILabel *totalTimeTitleLabel;
@property (strong, nonatomic) UILabel *totalDistanceTitleLabel;

@property (strong, nonatomic) UILabel *currentSpeedLabel;
@property (strong, nonatomic) UILabel *averageSpeedLabel;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (strong, nonatomic) UILabel *totalDistanceLabel;

@property (strong, nonatomic) NSTimer *timer;

- (void)updateTime;
- (id)initWithViewModel:(JCCaptureViewModel *)captureViewModel;
@end
