//
//  JCRouteViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteViewModel.h"

@implementation JCRouteViewModel
@synthesize name, safetyRating, environmentRating, difficultyRating, distanceMetres, estimatedTime, routeImage;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (NSNumber *)averageRating
{
    return @(([environmentRating intValue] + [difficultyRating intValue] + [safetyRating intValue]) / 3);
}

- (NSString *)readableTime
{
    int seconds = [self.estimatedTime intValue];
    int hours = seconds / 3600;
    int minutes = (seconds - (hours * 3600)) / 60;
    NSString *minuteDesc = minutes == 1 ? @"minute" : @"minutes";
    NSString *hourDesc = hours == 1 ? @"hour" : @"hours";
    if (hours == 0) {
        return [NSString stringWithFormat:@"Around %2d %@", minutes, minuteDesc];
    } else if (minutes == 0) {
        return [NSString stringWithFormat:@"Around %d %@", hours, hourDesc];
    } else {
        return [NSString stringWithFormat:@"Around %d %@ and %2d %@", hours, hourDesc,
                minutes, minuteDesc];
    }
}

@end
