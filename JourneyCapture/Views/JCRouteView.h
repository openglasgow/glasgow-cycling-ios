//
//  JCRouteView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 12/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;
@class JCRouteViewModel;

@interface JCRouteView : UIView

@property (strong, nonatomic) JCRouteViewModel *viewModel;
@property (strong, nonatomic) MKMapView *mapView;

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel;
- (void)drawRoute;

@end
