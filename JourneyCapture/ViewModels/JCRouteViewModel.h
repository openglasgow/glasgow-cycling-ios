//
//  JCRouteViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCRouteViewModel : RVMViewModel
// TODO make real data with nsdate etc.
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *safetyRating;
@property (strong, nonatomic) NSString *lastUsed;
@property (strong, nonatomic) NSString *estimatedTime;
@property (strong, nonatomic) NSString *distanceKm;
@property (strong, nonatomic) UIImage *routeImage;
@end
