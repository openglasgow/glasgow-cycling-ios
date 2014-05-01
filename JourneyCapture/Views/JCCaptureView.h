//
//  JCCaptureView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;
#import "JBLineChartView.h"

@class JCRouteViewModel;
@class JCCaptureStatsView;

@interface JCCaptureView : UIView <MKMapViewDelegate, JBLineChartViewDelegate, JBLineChartViewDataSource>
@property (strong, nonatomic) JCRouteViewModel *viewModel;

// Map
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;

@property (strong, nonatomic) JBLineChartView *graphView;
@property (strong, nonatomic) JCCaptureStatsView *statsView;

@property (strong, nonatomic) UIButton *captureButton;

- (id)initWithViewModel:(JCRouteViewModel *)captureViewModel;
- (void)updateRouteLine;
@end
