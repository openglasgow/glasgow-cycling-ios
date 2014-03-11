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

@property (readwrite, nonatomic) double currentSpeed;
@property (readwrite, nonatomic) double averageSpeed;
@property (readwrite, nonatomic) double totalMetres;
@property (strong, nonatomic) NSMutableArray *points;

@property (readwrite, nonatomic) NSInteger routeId;
@property (readwrite, nonatomic) double safetyRating;
@property (readwrite, nonatomic) double environmentRating;
@property (readwrite, nonatomic) double difficultyRating;

-(void)addPoint:(JCRoutePointViewModel *)point;
-(RACSignal *)uploadRoute;
-(RACSignal *)uploadReview;

@end
