//
//  JCWeatherViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 06/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCWeatherViewModel.h"
#import "JCAPIManager.h"

@implementation JCWeatherViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _weatherSource = @"Powered by forecast.io";
    [self loadWeather];
    return self;
}

-(void)loadWeather
{
    NSLog(@"Loading weather");
    JCAPIManager *manager = [JCAPIManager manager];
    [manager GET:@"/weather.json"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             [self setPrecipitation:responseObject[@"precipitation_probability"]];
             [self setTemperatureCelsius:responseObject[@"temp"]];
             
             [self setWindSpeed:responseObject[@"wind_speed"]];
             [self setWeatherIconName:responseObject[@"icon"]];
             [self setWeatherIcon:[UIImage imageNamed:_weatherIconName]];
             [self setWeatherError:nil];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self setWeatherError:@"Error finding weather"]; //TODO User better error message from server??
             [self setWeatherIconName:@"sad-face"];
             [self setWeatherIcon:[UIImage imageNamed:_weatherIconName]];
             
             NSLog(@"User load failure");
             NSLog(@"%@", error);
         }
     ];
}

@end
