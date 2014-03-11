//
//  JCRouteViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCRouteViewModel : RVMViewModel
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *estimatedTime;
@property (strong, nonatomic) NSNumber *distanceKm;
@property (strong, nonatomic) NSNumber *safetyRating;
@property (strong, nonatomic) NSNumber *environmentRating;
@property (strong, nonatomic) NSNumber *difficultyRating;
@property (strong, nonatomic) UIImage *routeImage;

- (NSNumber *)averageRating;
- (NSString *)readableTime;
@end
