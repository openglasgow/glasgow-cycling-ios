//
//  JCWeatherViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 06/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCWeatherViewModel.h"

@implementation JCWeatherViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _precipitation = @(0.95);
    _temperatureCelsius = @8;
    _uvIndex = @0;
    _windSpeed = @12;
    _weatherIcon = [UIImage imageNamed:@"confused-icon"];
    _weatherSource = @"Powered by forecast.io";
    
    return self;
}

@end
