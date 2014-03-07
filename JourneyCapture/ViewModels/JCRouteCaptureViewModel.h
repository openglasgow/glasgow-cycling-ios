//
//  JCRouteCaptureViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@class JCRoutePointViewModel;

@interface JCRouteCaptureViewModel : RVMViewModel

@property (readwrite, nonatomic, setter = setCurrentSpeed:) double currentSpeed;
@property (readwrite, nonatomic) double averageSpeed;
@property (readwrite, nonatomic) double totalMetres;
@property (strong, nonatomic) NSMutableArray *points;

-(void)addPoint:(JCRoutePointViewModel *)point;

@end
