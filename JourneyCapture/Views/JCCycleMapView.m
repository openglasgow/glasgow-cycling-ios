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
    for (JCCycleMapLocationViewModel *location in _viewModel.locations) {
        JCCycleMapAnnotation *annotation = [JCCycleMapAnnotation new];
        annotation.viewModel = location;
        annotation.title = location.name;
        annotation.coordinate = location.coordinate;
        [_mapView addAnnotation:annotation];
    }
}

@end
