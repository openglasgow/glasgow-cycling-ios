//
//  JCJourneyViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCJourneyViewModel : RVMViewModel

@property (strong, nonatomic) NSNumber *averageTime;
@property (strong, nonatomic) NSNumber *averageMiles;
@property (strong, nonatomic) NSString *name;
@property (readwrite, nonatomic) NSInteger numRoutes;
@property (readwrite, nonatomic) NSInteger numReviews;

@property (readwrite, nonatomic) double safetyRating;
@property (readwrite, nonatomic) double environmentRating;
@property (readwrite, nonatomic) double difficultyRating;
@property (readwrite, nonatomic) double averageRating;

@property (strong, nonatomic) NSString *startMaidenhead;
@property (strong, nonatomic) NSString *endMaidenhead;

- (NSString *)readableTime;

@end
