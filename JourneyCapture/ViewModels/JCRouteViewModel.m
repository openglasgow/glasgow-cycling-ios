//
//  JCRouteViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteViewModel.h"

@implementation JCRouteViewModel
@synthesize name, safetyRating, lastUsed, estimatedTime, distanceKm, routeImage;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

@end
