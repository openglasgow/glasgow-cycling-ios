//
//  JCStatsViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCStatsViewModel.h"

@implementation JCStatsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _periods = @[@3.3, @2.3, @1.1, @4.5, @6.2];
        _title = @"Distance";
    }
    return self;
}

@end
