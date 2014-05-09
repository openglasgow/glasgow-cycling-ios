//
//  JCPathViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 08/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCPathViewModel : RVMViewModel

// Location
@property (strong, nonatomic) NSMutableArray *points;
@property (strong, nonatomic) NSString *startMaidenhead;
@property (strong, nonatomic) NSString *endMaidenhead;

// Info
@property (strong, nonatomic) NSNumber *time;
@property (strong, nonatomic) NSNumber *averageMiles;
@property (strong, nonatomic) NSString *name;
@property (readwrite, nonatomic) NSInteger numInstances;
@property (readwrite, nonatomic) NSInteger numReviews;

// Review
@property (readwrite, nonatomic) double safetyRating;
@property (readwrite, nonatomic) double environmentRating;
@property (readwrite, nonatomic) double difficultyRating;

- (RACSignal *)readableInstanceCount;
- (NSString *)readableTime;
- (NSNumber *)averageRating;

@end
