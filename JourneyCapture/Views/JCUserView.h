//
//  JCUserView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;

@class JCUserViewModel;

@interface JCUserView : UIView
@property (strong, nonatomic) JCUserViewModel *viewModel;

@property (strong, nonatomic) UIScrollView *scrollView;

// Profile area
@property (strong, nonatomic) UIView *profileBackgroundView;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *distanceThisMonthLabel;
@property (strong, nonatomic) UILabel *timeThisMonthLabel;

// Capture area
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIImageView *captureImageView;
@property (strong, nonatomic) UIButton *captureButton;

// Menu area
@property (strong, nonatomic) UITableView *menuTableView;

- (id)initWithViewModel:(JCUserViewModel *)userViewModel;
@end
