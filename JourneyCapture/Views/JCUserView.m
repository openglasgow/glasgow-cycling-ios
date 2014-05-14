//
//  JCUserView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import QuartzCore;

#import "JCUserView.h"
#import "JCUserViewModel.h"
#import "JCScrollView.h"
#import "JCWeatherView.h"
#import "JCWeatherViewModel.h"

@implementation JCUserView

- (id)initWithViewModel:(JCUserViewModel *)userViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = userViewModel;
    self.backgroundColor = [UIColor whiteColor];
    
    // Scroll
    _scrollView = [JCScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
    // Pulldown area
    JCWeatherViewModel *weatherVM = [JCWeatherViewModel new];
    _pulldownView = [[JCWeatherView alloc] initWithViewModel:weatherVM];
    _pulldownView.translatesAutoresizingMaskIntoConstraints = NO;
    _pulldownView.backgroundColor = [UIColor jc_lightBlueColor];
    [_scrollView addSubview:_pulldownView];

    // Profile
    _profileBackgroundView = [UIView new];
    _profileBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _profileBackgroundView.backgroundColor = [UIColor jc_blueColor];
    [_scrollView addSubview:_profileBackgroundView];
    
    _profileImageView = [UIImageView new];
    _profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    RACChannelTo(_profileImageView, image) = RACChannelTo(_viewModel, profilePic);

    // Mask profile pic
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.cornerRadius = 56.0f;
    _profileImageView.layer.borderWidth = 4.0f;
    _profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_scrollView addSubview:_profileImageView];
    
    // Profile stats
    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue" size:12.0];

    // Monthly time
    _timeThisMonthLabel = [UILabel new];
    _timeThisMonthLabel.textColor = [UIColor whiteColor];
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
    [_scrollView addSubview:_timeThisMonthLabel];

    // Monthly distance
    _distanceThisMonthLabel = [UILabel new];
    _distanceThisMonthLabel.textColor = [UIColor whiteColor];
    _distanceThisMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_distanceThisMonthLabel setFont:statsFont];
    RACChannelTerminal *distanceLabelChannel = RACChannelTo(self, distanceThisMonthLabel.text);
    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.kmThisMonth);
    [[distanceModelChannel map:^(NSNumber *kmThisMonth){
        return [NSString stringWithFormat:@"%.02f km this month", [kmThisMonth doubleValue]];
    }] subscribe:distanceLabelChannel];
    [_scrollView addSubview:_distanceThisMonthLabel];

    // Capture area
    _mapView = [MKMapView new];
    _mapView.zoomEnabled = NO;
    _mapView.scrollEnabled = NO;
    _mapView.rotateEnabled = NO;
    _mapView.pitchEnabled = NO;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_mapView];
    
    _captureButton = [UIButton new];
    _captureButton.translatesAutoresizingMaskIntoConstraints = NO;
    _captureButton.layer.masksToBounds = YES;
    _captureButton.layer.cornerRadius = 33.75f;
    [_scrollView addSubview:_captureButton];

    UIImage *captureImage = [UIImage imageNamed:@"capture-button"];
    UIImage *captureTappedImage = [UIImage imageNamed:@"capture-button-tapped"];
    [_captureButton setImage:captureImage forState:UIControlStateNormal];
    [_captureButton setImage:captureTappedImage forState:UIControlStateHighlighted];
    
    // Menu area
    _menuTableView = [UITableView new];
    _menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_menuTableView];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    // Scroll
    [_scrollView autoRemoveConstraintsAffectingView];
    [_scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    // Pulldown area
    [_pulldownView autoRemoveConstraintsAffectingView];
    [_pulldownView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView];
    [_pulldownView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_scrollView];
    [_pulldownView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView withOffset:-1000.0f];
    [_pulldownView autoSetDimension:ALDimensionHeight toSize:1000.0f];
    
    // Profile
    [_profileBackgroundView autoRemoveConstraintsAffectingView];
    [_profileBackgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_profileBackgroundView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView];
    [_profileBackgroundView autoSetDimension:ALDimensionHeight toSize:213.0f];
    [_profileBackgroundView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    
    [_profileImageView autoRemoveConstraintsAffectingView];
    [_profileImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView withOffset:28];
    [_profileImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_profileImageView autoSetDimensionsToSize:CGSizeMake(112, 112)];
    
    [_distanceThisMonthLabel autoRemoveConstraintsAffectingView];
    [_distanceThisMonthLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_profileImageView withOffset:5];
    [_distanceThisMonthLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];

    [_timeThisMonthLabel autoRemoveConstraintsAffectingView];
    [_timeThisMonthLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_distanceThisMonthLabel withOffset:5];
    [_timeThisMonthLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    // Capture
    [_mapView autoRemoveConstraintsAffectingView];
    [_mapView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_profileBackgroundView];
    [_mapView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView];
    [_mapView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_scrollView];
    [_mapView autoSetDimension:ALDimensionHeight toSize:128];
    
    [_captureButton autoRemoveConstraintsAffectingView];
    [_captureButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_captureButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_mapView withOffset:15];
    [_captureButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_mapView withOffset:-15];
    [_captureButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_captureButton];

    // Menu
    [_menuTableView autoRemoveConstraintsAffectingView];
    [_menuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_menuTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mapView];
    [_menuTableView autoSetDimension:ALDimensionHeight toSize:180];

    [super layoutSubviews];
}

@end
