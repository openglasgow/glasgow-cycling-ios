//
//  JCRouteViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPathViewModel.h"
#import <MapKit/MapKit.h>


@interface JCRouteViewModel : JCPathViewModel

// Review data
@property (readwrite, nonatomic) NSInteger routeId;
@property (readwrite, nonatomic) double rating;

- (RACSignal *)loadPoints;
- (CLLocationCoordinate2D)startCircleCoordinate;
- (CLLocationCoordinate2D)endCircleCoordinate;
- (CLLocationCoordinate2D)locationWithBearing:(float)bearing distance:(float)distanceMeters fromLocation:(CLLocationCoordinate2D)origin;
- (void)submitReview;
@end
