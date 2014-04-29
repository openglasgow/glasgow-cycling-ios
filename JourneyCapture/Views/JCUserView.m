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
    self.backgroundColor = [UIColor whiteColor];
    
    // Scroll
    _scrollView = [UIScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_scrollView];
    
    // Pulldown area
    _pulldownBackgroundView = [UIView new];
    _pulldownBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _pulldownBackgroundView.backgroundColor = [UIColor jc_lightBlueColor];
    [_scrollView addSubview:_pulldownBackgroundView];

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
    _mapView.userInteractionEnabled = NO;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_mapView];
    
    UIImage *captureImage = [UIImage imageNamed:@"capture-icon"];
    _captureImageView = [[UIImageView alloc] initWithImage:captureImage];
    _captureImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _captureImageView.layer.masksToBounds = YES;
    _captureImageView.layer.cornerRadius = 33.75f;
    [_scrollView addSubview:_captureImageView];
    
    _captureButton = [UIButton new];
    _captureButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_captureButton];
    
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
    [_pulldownBackgroundView autoRemoveConstraintsAffectingView];
    [_pulldownBackgroundView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView];
    [_pulldownBackgroundView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_scrollView];
    [_pulldownBackgroundView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_profileBackgroundView];
    [_pulldownBackgroundView autoSetDimension:ALDimensionHeight toSize:1000.0f];
    
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
    
    [_captureImageView autoRemoveConstraintsAffectingView];
    [_captureImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_captureImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_mapView withOffset:30];
    [_captureImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_mapView withOffset:-30];
    [_captureImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_captureImageView];

    [_captureButton autoRemoveConstraintsAffectingView];
    [_captureButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_mapView];
    [_captureButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_mapView];
    [_captureButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_mapView];
    [_captureButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_mapView];
    
    // Menu
    [_menuTableView autoRemoveConstraintsAffectingView];
    [_menuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_menuTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mapView];
    [_menuTableView autoSetDimension:ALDimensionHeight toSize:240];

    [super layoutSubviews];
}

@end
