//
//  JCCycleMapView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCycleMapView.h"
#import "JCCycleMapViewModel.h"
#import "JCCycleMapLocationViewModel.h"
#import "JCCycleMapAnnotation.h"
#import "JCLocationManager.h"

@implementation JCCycleMapView

#pragma mark - Lifecycle

- (id)initWithViewModel:(JCCycleMapViewModel *)mapViewModel
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _viewModel = mapViewModel;
    
    _mapView = [MKMapView new];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_mapView];
    
    return self;
}

- (void)layoutSubviews
{
    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [super layoutSubviews];
}

#pragma mark - JCCycleMapView

- (void)updateMap
{
    // Add annotations
    [_mapView removeAnnotations:_mapView.annotations];
    for (JCCycleMapLocationViewModel *location in _viewModel.locations) {
        JCCycleMapAnnotation *annotation = [JCCycleMapAnnotation new];
        annotation.viewModel = location;
        annotation.title = location.name;
        annotation.coordinate = location.coordinate;
        [_mapView addAnnotation:annotation];
    }
    
    // Zoom to user region
    CLLocationCoordinate2D userLoc = [[JCLocationManager sharedManager] currentLocation].coordinate;
    MKMapRect zoomRect = MKMapRectMake(userLoc.latitude - 0, userLoc.longitude - 0, 10, 10);
    [_mapView setVisibleMapRect:zoomRect animated:YES];
}

@end
