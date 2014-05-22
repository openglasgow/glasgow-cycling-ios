//
//  JCStatViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 21/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//
//  Exposes a single stat from JCUsageViewModel
//

#import "JCStatViewModel.h"
#import "JCUsageViewModel.h"

@implementation JCStatViewModel

- (instancetype)initWithUsage:(JCUsageViewModel *)usageViewModel
                   displayKey:(NSString *)displayKey title:(NSString *)title
{
    self = [super init];
    if (self) {
        _stats = usageViewModel;
        _title = title;
        _displayKey = displayKey;
    }
    return self;
}

- (NSInteger)countOfStats
{
    return _stats.periods.count;
}

- (CGFloat)statValueAtIndex:(NSUInteger)index
{
    NSDictionary *period = _stats.periods[index];
    if (!period) {
        return 0.0;
    }
    
    NSNumber *stat = period[_displayKey];
    return [stat floatValue];
}

- (NSString *)statDisplayStringForIndex:(NSUInteger)index
{
    CGFloat value = [self statValueAtIndex:index];
    if (kStatsDistanceKey == _displayKey) {
        CGFloat distanceMiles = value * 0.621371192f;
        NSString *distDescription;
        if (distanceMiles >= 0.95 && distanceMiles < 1.05) {
            distDescription = @"mile";
        } else {
            distDescription = @"miles";
        }
        return [NSString stringWithFormat:@"%.1f %@", distanceMiles, distDescription];
    } else if (kStatsRoutesCompletedKey == _displayKey) {
        NSString *routeDescription;
        if (value == 1) {
            routeDescription = @"route";
        } else {
            routeDescription = @"routes";
        }
        return [NSString stringWithFormat:@"%.0f %@", value, routeDescription];
    }
    
    return [NSString stringWithFormat:@"%f", value];
}

@end
