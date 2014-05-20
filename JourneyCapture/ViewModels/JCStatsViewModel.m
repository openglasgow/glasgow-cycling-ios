//
//  JCStatsViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCStatsViewModel.h"

@implementation JCStatsViewModel

NSString * kStatsDistanceKey = @"distance";

- (instancetype)init
{
    self = [super init];
    if (self) {
        _title = @"Distance";
        _displayKey = kStatsDistanceKey;
        [self loadStatsForDays:7];
    }
    return self;
}

- (void)loadStatsForDays:(NSInteger)numDays
{
    _periods = @[
                 @{@"distance": @13.3},
                 @{@"distance": @3.3},
                 @{@"distance": @3.3},
                 @{@"distance": @3.3},
                 @{@"distance": @3.3},
                 @{@"distance": @3.3},
                 @{@"distance": @3.3},
                 ];
}

@end
