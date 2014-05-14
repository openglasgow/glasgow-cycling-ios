//
//  JCWeatherViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 06/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
@class Weather;

@interface JCWeatherViewModel : RVMViewModel
@property (strong, nonatomic) Weather *weather;
@property (strong, nonatomic) NSString *weatherIconName;
@property (strong, nonatomic) NSNumber *precipitation;
@property (strong, nonatomic) NSNumber *temperatureCelsius;
@property (strong, nonatomic) NSNumber *uvIndex;
@property (strong, nonatomic) NSNumber *windSpeed;
@property (strong, nonatomic) NSString *weatherSource;
@property (strong, nonatomic) UIImage *weatherIcon;
@property (strong, nonatomic) NSString *weatherError;

- (void)loadWeather;
- (void)loadFromWeather:(Weather *)weatherModel;
@end
