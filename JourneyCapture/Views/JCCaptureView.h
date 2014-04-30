//
//  JCCaptureView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;

@class JCRouteViewModel;

@interface JCCaptureView : UIView <MKMapViewDelegate>
@property (strong, nonatomic) JCRouteViewModel *viewModel;

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) MKPolyline *routeLine;
@property (nonatomic, strong) MKPolylineView *routeLineView;

@property (strong, nonatomic) UIButton *captureButton;

- (id)initWithViewModel:(JCRouteViewModel *)captureViewModel;
- (void)updateRouteLine;
@end
