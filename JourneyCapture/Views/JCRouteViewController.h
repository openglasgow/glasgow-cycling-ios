//
//  JCRouteViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class JCRouteViewModel;

@interface JCRouteViewController : UIViewController
@property (strong, nonatomic) JCRouteViewModel *viewModel;
@property (strong, nonatomic) UIImageView *routeImageView;
@property (strong, nonatomic) MKMapView *mapView;
- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel;
@end
