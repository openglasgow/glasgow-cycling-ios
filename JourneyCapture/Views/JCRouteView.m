//
//  JCRouteView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteView.h"
#import "JCRouteViewModel.h"
#import "JCRoutePointViewModel.h"

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
    _mapView.delegate = self;
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_mapView];
    
    return self;
}

- (void)drawRoute
{
    // Draw points
    NSUInteger numPoints = [self.viewModel.points count];
    
    if (numPoints < 2) {
        return;
    }
    
    MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D)*numPoints);
    for (int i = 0; i < numPoints; i++) {
        JCRoutePointViewModel *point = self.viewModel.points[i];
        pointsArray[i] = MKMapPointForCoordinate(point.location.coordinate);
    }
    
    MKPolyline *routeLine = [MKPolyline polylineWithPoints:pointsArray count:numPoints];
    free(pointsArray);
    
    [_mapView addOverlay:routeLine];
    
    // Zoom to points
    MKMapRect zoomRect = MKMapRectNull;
    for (JCRoutePointViewModel *point in self.viewModel.points)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(point.location.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 350.0, 350.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    MKMapRect paddedZoomRect = MKMapRectMake(zoomRect.origin.x - 4000, zoomRect.origin.y -= 4000,
                                             zoomRect.size.width + 8000, zoomRect.size.height + 8000);
    
    [_mapView setVisibleMapRect:paddedZoomRect animated:YES];
}

# pragma mark - UIView

- (void)layoutSubviews
{
    [_mapView autoRemoveConstraintsAffectingView];
    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_mapView autoSetDimension:ALDimensionHeight toSize:362];
    
    [super layoutSubviews];
}

# pragma mark - MKMapVIew

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor jc_blueColor];
    renderer.lineWidth = 3.5;
    return  renderer;
}

@end
