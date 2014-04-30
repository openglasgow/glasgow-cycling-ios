//
//  JCCaptureView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import QuartzCore;
#import "JCCaptureView.h"
#import "JCRouteViewModel.h"
#import "JCRoutePointViewModel.h"

@implementation JCCaptureView

- (id)initWithViewModel:(JCRouteViewModel *)captureViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Map view
    _mapView = [MKMapView new];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    _mapView.zoomEnabled = NO;
    _mapView.scrollEnabled = NO;
    _mapView.userInteractionEnabled = NO;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_mapView];

    // Capture button
    UIColor *buttonColor = [UIColor jc_redColor];
    _captureButton = [UIButton new];
    _captureButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_captureButton setTitle:@"Finish Route" forState:UIControlStateNormal];
    [_captureButton setBackgroundColor:buttonColor];
    _captureButton.layer.masksToBounds = YES;
    _captureButton.layer.cornerRadius = 8.0f;
    [self addSubview:_captureButton];

    // Stats

    return self;
}

- (void)updateRouteLine
{
    NSUInteger numPoints = [_viewModel.points count];

    if (numPoints < 2) {
        return;
    }

    JCRoutePointViewModel *point = _viewModel.points[numPoints-1];
    CLLocationCoordinate2D coord = point.location.coordinate;

    JCRoutePointViewModel *previousPoint = _viewModel.points[numPoints-2];
    CLLocationCoordinate2D previousCoord = previousPoint.location.coordinate;

    MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
    pointsArray[0]= MKMapPointForCoordinate(previousCoord);
    pointsArray[1]= MKMapPointForCoordinate(coord);

    _routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
    free(pointsArray);

    [[self mapView] addOverlay:_routeLine];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_mapView autoRemoveConstraintsAffectingView];
    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_mapView autoSetDimension:ALDimensionHeight toSize:230];
    
    [_captureButton autoRemoveConstraintsAffectingView];
    [_captureButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15, 15, 15, 15) excludingEdge:ALEdgeTop];
    [_captureButton autoSetDimension:ALDimensionHeight toSize:42.5f];
    
    [super layoutSubviews];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = self.tintColor;
    renderer.lineWidth = 2.5;
    return  renderer;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Ensure mapview is zoomed in to a reasonable amount when user location is found
    // (seems to be an issue with mapView userTrackingEnabled where this sometimes doesn't happen)
    MKCoordinateSpan zoomSpan = _mapView.region.span;
    if (zoomSpan.latitudeDelta > 1 || zoomSpan.longitudeDelta > 1) {
        // 1 might be a bit large, but delta is typically initially ~50-55
        CLLocationCoordinate2D loc = [userLocation coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
        [_mapView setRegion:region animated:YES];
    }
}

@end