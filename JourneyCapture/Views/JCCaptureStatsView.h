//
//  JCCaptureStatsView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 30/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCRouteViewModel;

@interface JCCaptureStatsView : UIView
@property (strong, nonatomic) JCRouteViewModel *viewModel;

@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) UILabel *currentSpeedLabel;
@property (strong, nonatomic) UILabel *averageSpeedLabel;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (strong, nonatomic) UILabel *totalDistanceLabel;

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel;
@end
