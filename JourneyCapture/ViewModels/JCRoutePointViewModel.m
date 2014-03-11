//
//  JCRoutePointViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRoutePointViewModel.h"

@implementation JCRoutePointViewModel
@synthesize location;

-(NSDictionary *)data
{
    return @{
             @"lat": @(self.location.coordinate.latitude),
             @"long": @(self.location.coordinate.longitude),
             @"speed": @(self.location.speed),
             @"altitude": @(self.location.altitude),
             @"time": @([self.location.timestamp timeIntervalSince1970])
            };
}
@end
