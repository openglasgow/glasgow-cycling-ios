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

@interface JCCaptureViewModel : RVMViewModel

@property (strong, nonatomic) NSMutableArray *points;
@property (readwrite, nonatomic) double lastGeocodedKm;
@property (readwrite, nonatomic) NSInteger routeId;
@property (readwrite, nonatomic) NSInteger totalKm;
@property (readwrite, nonatomic) CLLocationSpeed currentSpeed;
@property (readwrite, nonatomic) CLLocationSpeed averageSpeed;

-(void)addPoint:(JCRoutePointViewModel *)point;
- (RACSignal *)uploadRoute;

@end
