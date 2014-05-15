//
//  JCCaptureViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 08/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
#import "JCRoutePointViewModel.h"

@class JCRoutePointViewModel;
@class Route;

@interface JCCaptureViewModel : RVMViewModel

@property (strong, nonatomic) Route *route;

@property (readwrite, nonatomic) double lastGeocodedKm;
@property (readwrite, nonatomic) NSInteger routeId;
@property (readwrite, nonatomic) CGFloat totalKm;
@property (readwrite, nonatomic) CLLocationSpeed currentSpeed;
@property (readwrite, nonatomic) CLLocationSpeed averageSpeed;

- (instancetype)initWithModel:(Route *)routeModel;
- (void)commonInit;
- (void)addLocation:(CLLocation *)location;
- (void)setCompleted;
- (NSOrderedSet *)points;
- (RACSignal *)uploadRoute;

@end
