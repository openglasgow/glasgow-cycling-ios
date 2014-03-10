//
//  JCCaptureView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class JCRouteCaptureViewModel;

@interface JCCaptureView : UIView <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapview;
@property (nonatomic, strong) MKPolyline *routeLine;
@property (nonatomic, strong) MKPolylineView *routeLineView;
@property (strong, nonatomic) UIButton *captureButton;
@property (strong, nonatomic) UITableView *statsTable;
@property (strong, nonatomic) JCRouteCaptureViewModel *viewModel;

- (id)initWithFrame:(CGRect)frame viewModel:(JCRouteCaptureViewModel *)captureViewModel;
- (void)transitionToActive;
- (void)updateRoute;
@end
