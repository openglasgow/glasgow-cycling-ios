//
//  JCUserView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;

@class JCUserViewModel, JCUserHeaderView, JCWeatherView;

@interface JCUserView : UIView
@property (strong, nonatomic) JCUserViewModel *viewModel;

@property (strong, nonatomic) UIScrollView *scrollView;

// Pull down area (weather)
@property (strong, nonatomic) JCWeatherView *pulldownView;

// Profile area
@property (strong, nonatomic) JCUserHeaderView *headerView;

// Capture area
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIButton *captureButton;

// Menu area
@property (strong, nonatomic) UITableView *menuTableView;

- (id)initWithViewModel:(JCUserViewModel *)userViewModel;
@end
