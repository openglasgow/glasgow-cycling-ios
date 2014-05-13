//
//  JCRouteViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;
@class JCRouteViewModel;
@class JCRouteView;

@interface JCRouteViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) JCRouteViewModel *viewModel;
@property (strong, nonatomic) JCRouteView *routeView;
- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel;
@end
