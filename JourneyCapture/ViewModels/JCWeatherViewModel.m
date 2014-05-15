//
//  JCWeatherViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 06/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCWeatherViewModel.h"
#import "JCAPIManager.h"
#import "Weather.h"

@implementation JCWeatherViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    // Weather model
    if ([Weather MR_countOfEntities] > 0) {
        _weather = [Weather MR_findFirst];
        if (!_weather.time || _weather.time < [NSDate dateWithTimeIntervalSinceNow:-3600]) {
            [Weather MR_truncateAll];
        }
    }
    
    if ([Weather MR_countOfEntities] == 0) {
        _weather = [Weather MR_createEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saved weather model");
    }];
    
    [self loadFromWeather:_weather];
    
    return self;
}

- (void)loadWeather
{
    NSLog(@"Loading weather");
    JCAPIManager *manager = [JCAPIManager manager];
    [manager GET:@"/weather.json"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             _weather.precipitation = responseObject[@"precipitation_probability"];
             _weather.temperature = responseObject[@"temp"];
             _weather.windSpeed = responseObject[@"wind_speed"];
             _weather.iconName = responseObject[@"icon"];
             _weather.time = [NSDate dateWithTimeIntervalSince1970:[responseObject[@"time"] intValue]];
             _weather.source = responseObject[@"source"];
             [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                 NSLog(@"Saved weather model");
                 [self loadFromWeather:_weather];
             }];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // Only show weather error if cache is outdated
             if (!_weather.time || _weather.time < [NSDate dateWithTimeIntervalSinceNow:-3600]) {
                 [Weather MR_truncateAll];
                 [self setWeatherError:@"Error finding weather"]; //TODO Use better error message from server??
                 [self setWeatherIconName:@"sad-face"];
                 [self setWeatherIcon:[UIImage imageNamed:_weatherIconName]];
             }
             
             NSLog(@"Weather load failure");
             NSLog(@"%@", error);
         }
     ];
}

- (void)loadFromWeather:(Weather *)weatherModel
{
    [self setPrecipitation:_weather.precipitation];
    [self setTemperatureCelsius:_weather.temperature];
    [self setWindSpeed:_weather.windSpeed];
    [self setWeatherIconName:_weather.iconName];
    [self setWeatherIcon:[UIImage imageNamed:_weatherIconName]];
    [self setWeatherSource:_weather.source];
    [self setWeatherError:nil];
}

@end
