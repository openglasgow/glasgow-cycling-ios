//
//  JCRouteView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 12/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;
#import "EDStarRating.h"
@class JCRouteViewModel;

@interface JCRouteView : UIView <MKMapViewDelegate, EDStarRatingProtocol>

@property (strong, nonatomic) JCRouteViewModel *viewModel;
@property (strong, nonatomic) MKMapView *mapView;

// Stats
@property (strong, nonatomic) UILabel *timeTitleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *distanceTitleLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *avgSpeedTitleLabel;
@property (strong, nonatomic) UILabel *avgSpeedLabel;

@property (strong, nonatomic) EDStarRating *reviewStarView;

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel;
- (void)drawRoute;

@end
