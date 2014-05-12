//
//  JCRouteView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteView.h"
#import "JCRouteViewModel.h"

@implementation JCRouteView

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _viewModel = routeViewModel;
    
    // Map
    _mapView = [MKMapView new];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_mapView];
    
    return self;
}

# pragma mark - UIView

- (void)layoutSubviews
{
    [_mapView autoRemoveConstraintsAffectingView];
    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_mapView autoSetDimension:ALDimensionHeight toSize:362];
    
    [super layoutSubviews];
}

@end
