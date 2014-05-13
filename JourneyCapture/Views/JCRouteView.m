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
    
//    // Map
//    _mapView = [MKMapView new];
//    _mapView.delegate = self;
//    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_mapView];
//    
//    // Stats
//    _timeTitleLabel = [UILabel new];
//    _timeTitleLabel.text = @"Time";
//    _timeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_timeTitleLabel];
//    
//    _timeLabel = [UILabel new];
//    _timeLabel.text = @"3:15:30";
//    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_timeLabel];
//    
//    _distanceTitleLabel = [UILabel new];
//    _distanceTitleLabel.text = @"Distance";
//    _distanceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_distanceTitleLabel];
//    
//    _distanceLabel = [UILabel new];
//    _distanceLabel.text = @"34.5 miles";
//    _distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_distanceLabel];
//    
//    _avgSpeedTitleLabel = [UILabel new];
//    _avgSpeedTitleLabel.text = @"Avg Speed";
//    _avgSpeedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_avgSpeedTitleLabel];
//    
//    _avgSpeedLabel = [UILabel new];
//    _avgSpeedLabel.text = @"26 mph";
//    _avgSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_avgSpeedLabel];
    
    // Star Rating
    _reviewStarView = [[EDStarRating alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _reviewStarView.editable = YES;
    _reviewStarView.translatesAutoresizingMaskIntoConstraints = NO;
    _reviewStarView.displayMode = EDStarRatingDisplayFull;
    _reviewStarView.starImage = [UIImage imageNamed:@"star"];
    _reviewStarView.starHighlightedImage = [UIImage imageNamed:@"filled-star"];
    _reviewStarView.rating = 3;
    _reviewStarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_reviewStarView];
    
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
    [_reviewStarView autoRemoveConstraintsAffectingView];
    [_reviewStarView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
    [_reviewStarView autoSetDimension:ALDimensionHeight toSize:26];
    [_reviewStarView autoSetDimension:ALDimensionWidth toSize:150];
    [_reviewStarView autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    
//    [_mapView autoRemoveConstraintsAffectingView];
//    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
//    [_mapView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_timeTitleLabel];
    
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
