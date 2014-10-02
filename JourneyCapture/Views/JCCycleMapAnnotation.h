//
//  JCCycleMapAnnotation.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import Foundation;
@import MapKit;
#import <OCMapView/OCMapView.h>

@interface JCCycleMapAnnotation : NSObject <MKAnnotation, OCGrouping>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *groupTag;
@property (strong, nonatomic) UIImage *image;
@end
