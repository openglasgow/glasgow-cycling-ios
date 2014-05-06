//
//  JCRouteViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@class JCRoutePointViewModel;

@interface JCRouteViewModel : RVMViewModel

// Location data
@property (readwrite, nonatomic) double currentSpeed;
@property (readwrite, nonatomic) double averageSpeed;
@property (readwrite, nonatomic) double totalKm;
@property (readwrite, nonatomic) double lastGeocodedKm;
@property (strong, nonatomic) NSMutableArray *points;

// Review data
@property (readwrite, nonatomic) NSInteger routeId;
@property (readwrite, nonatomic) double safetyRating;
@property (readwrite, nonatomic) double environmentRating;
@property (readwrite, nonatomic) double difficultyRating;

// Loaded route data
@property (strong, nonatomic) NSNumber *estimatedTime;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *routeImage;
@property (readwrite, nonatomic) NSInteger uses;
@property (readwrite, nonatomic) NSInteger numReviews;

-(void)addPoint:(JCRoutePointViewModel *)point;

- (RACSignal *)uploadRoute;
- (RACSignal *)uploadReview;

- (RACSignal *)loadPoints;
- (NSNumber *)averageRating;
- (NSString *)readableTime;
@end
