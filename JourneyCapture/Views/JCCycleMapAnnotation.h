//
//  JCCycleMapAnnotation.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import Foundation;
@import MapKit;
@class JCCycleMapLocationViewModel;

@interface JCCycleMapAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) JCCycleMapLocationViewModel *viewModel;
@end
