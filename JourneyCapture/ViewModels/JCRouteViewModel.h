//
//  JCRouteViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPathViewModel.h"

@interface JCRouteViewModel : JCPathViewModel

// Review data
@property (readwrite, nonatomic) NSInteger routeId;
@property (readwrite, nonatomic) double safetyRating;
@property (readwrite, nonatomic) double environmentRating;
@property (readwrite, nonatomic) double difficultyRating;

- (RACSignal *)uploadRoute;
- (RACSignal *)uploadReview;

- (RACSignal *)loadPoints;
@end
