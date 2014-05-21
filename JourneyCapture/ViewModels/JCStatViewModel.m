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

@end
