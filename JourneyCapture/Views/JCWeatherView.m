//
//  JCWeatherView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 06/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCWeatherView.h"
#import "JCWeatherViewModel.h"

@implementation JCWeatherView

- (id)initWithViewModel:(JCWeatherViewModel *)weatherViewModel
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _viewModel = weatherViewModel;
    
    // Icon
    _weatherIconView = [[UIImageView alloc] initWithImage:_viewModel.weatherIcon];
    _weatherIconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_weatherIconView];
    
    // Precipitation
    _precipitationTitleLabel = [UILabel new];
    _precipitationTitleLabel.text = @"Precipitation";
    _precipitationTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_precipitationTitleLabel];
    
    _precipitationLabel = [UILabel new];
    _precipitationLabel.text = [NSString stringWithFormat:@"%.02f", [_viewModel.precipitation doubleValue]];
    [self addSubview:_precipitationLabel];
    
    // Temperature
    _temperatureTitleLabel = [UILabel new];
    _temperatureTitleLabel.text = @"Temperature";
    [self addSubview:_temperatureTitleLabel];
    
    _temperatureLabel = [UILabel new];
    _temperatureLabel.text = [NSString stringWithFormat:@"%d°C", [_viewModel.temperatureCelsius intValue]];
    [self addSubview:_temperatureLabel];
    
    // UVIndex
    _uvIndexTitleLabel = [UILabel new];
    _uvIndexTitleLabel.text = @"UV Index";
    [self addSubview:_uvIndexTitleLabel];
    
    _uvIndexLabel = [UILabel new];
    _uvIndexLabel.text = [NSString stringWithFormat:@"%d", [_viewModel.uvIndex intValue]];
    [self addSubview:_uvIndexLabel];
    
    // Wind Speed
    _windSpeedTitleLabel = [UILabel new];
    _windSpeedTitleLabel.text = @"Wind Speed";
    [self addSubview:_windSpeedTitleLabel];
    
    _windSpeedLabel = [UILabel new];
    _windSpeedLabel.text = [NSString stringWithFormat:@"%d mph", [_viewModel.windSpeed intValue]];
    [self addSubview:_windSpeedLabel];
    
    // Weather Source
    _weatherSourceLabel = [UILabel new];
    _weatherSourceLabel.text = _viewModel.weatherSource;
    [self addSubview:_weatherSourceLabel];
    
    return self;
}

# pragma mark - UIView

- (void)layoutSubviews
{
    // Weather Icon
    [_weatherIconView autoRemoveConstraintsAffectingView];
    [_weatherIconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
    [_weatherIconView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-20];
    [_weatherIconView autoSetDimensionsToSize:CGSizeMake(20, 20)];

    // Precipitation
    [_precipitationTitleLabel autoRemoveConstraintsAffectingView];
    [_precipitationTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_weatherIconView withOffset:12];
    [_precipitationTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-40];
    
    [super layoutSubviews];
}



@end
