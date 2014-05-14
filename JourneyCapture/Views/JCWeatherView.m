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
    
    // Appearance
    UIFont *titleFont = [UIFont systemFontOfSize:12.0f];
    UIColor *titleColor = [UIColor whiteColor];
    UIFont *statFont = [UIFont systemFontOfSize:18.0f];
    UIColor *statColor = [UIColor whiteColor];
    UIFont *sourceFont = [UIFont systemFontOfSize:12.0f];
    UIColor *sourceColor = [UIColor colorWithRed:199/255.0f green:233/255.0f blue:246/255.0f alpha:1.0];
    
    // Icon
    _weatherIconView = [UIImageView new];
    [RACObserve(self, viewModel.weatherIcon) subscribeNext:^(UIImage *weatherIcon) {
        _weatherIconView.image = weatherIcon;
    }];
    _weatherIconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_weatherIconView];
    
    // Precipitation
    _precipitationTitleLabel = [UILabel new];
    _precipitationTitleLabel.text = @"Precipitation";
    _precipitationTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _precipitationTitleLabel.textColor = titleColor;
    _precipitationTitleLabel.font = titleFont;
    [self addSubview:_precipitationTitleLabel];
    
    _precipitationLabel = [UILabel new];
    [RACObserve(self, viewModel.precipitation) subscribeNext:^(NSNumber *precipitation) {
        double precip = [precipitation doubleValue];
        int percentage = round(precip * 100);
        _precipitationLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
    }];
    _precipitationLabel.font = statFont;
    _precipitationLabel.textColor = statColor;
    _precipitationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _precipitationLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_precipitationLabel];
    
    // Temperature
    _temperatureTitleLabel = [UILabel new];
    _temperatureTitleLabel.text = @"Temperature";
    _temperatureTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _temperatureTitleLabel.textColor = titleColor;
    _temperatureTitleLabel.font = titleFont;
    [self addSubview:_temperatureTitleLabel];
    
    _temperatureLabel = [UILabel new];
    [RACObserve(self, viewModel.temperatureCelsius) subscribeNext:^(NSNumber *temperature) {
        _temperatureLabel.text = [NSString stringWithFormat:@"%.0f°C", round(([temperature intValue]-32)/1.8)];
    }];
    _temperatureLabel.font = statFont;
    _temperatureLabel.textColor = statColor;
    _temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _temperatureLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_temperatureLabel];

    // Wind Speed
    _windSpeedTitleLabel = [UILabel new];
    _windSpeedTitleLabel.text = @"Wind Speed";
    _windSpeedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _windSpeedTitleLabel.textColor = titleColor;
    _windSpeedTitleLabel.font = titleFont;
    [self addSubview:_windSpeedTitleLabel];
    
    _windSpeedLabel = [UILabel new];
    [RACObserve(self, viewModel.windSpeed) subscribeNext:^(NSNumber *windSpeed) {
        _windSpeedLabel.text = [NSString stringWithFormat:@"%d mph", [windSpeed intValue]];
    }];
    _windSpeedLabel.font = statFont;
    _windSpeedLabel.textColor = statColor;
    _windSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _windSpeedLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_windSpeedLabel];
    
    // Weather Source
    _weatherSourceLabel = [UILabel new];
    _weatherSourceLabel.text = _viewModel.weatherSource;
    _weatherSourceLabel.font = sourceFont;
    _weatherSourceLabel.textColor = sourceColor;
    _weatherSourceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _weatherSourceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_weatherSourceLabel];
    
    // Error Message
    _errorLabel = [UILabel new];
    [RACObserve(self, viewModel.weatherError) subscribeNext:^(NSString *error) {
        _errorLabel.text = error;
    }];
    _errorLabel.font = statFont;
    _errorLabel.textColor = statColor;
    _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _errorLabel.minimumScaleFactor = 0.5f;
    _errorLabel.adjustsFontSizeToFitWidth = YES;
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_errorLabel];
    
    return self;
}

# pragma mark - UIView

- (void)layoutSubviews
{
    // Weather Icon
    [_weatherIconView autoRemoveConstraintsAffectingView];
    [_weatherIconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
    [_weatherIconView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-25];
    [_weatherIconView autoSetDimensionsToSize:CGSizeMake(20, 20)];
    
    if(_viewModel.weatherError){
        [_errorLabel setHidden:false];
        [_errorLabel autoRemoveConstraintsAffectingView];
        [_errorLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_weatherIconView withOffset:12];
        [_errorLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
        [_errorLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-25];
        
        // Hide others
        [_weatherSourceLabel setHidden:true];
        [_windSpeedLabel setHidden:true];
        [_temperatureLabel setHidden:true];
        [_precipitationLabel setHidden:true];
        [_windSpeedTitleLabel setHidden:true];
        [_temperatureTitleLabel setHidden:true];
        [_precipitationTitleLabel setHidden:true];
    } else{
        
        // Titles
        [_precipitationTitleLabel autoRemoveConstraintsAffectingView];
        [_precipitationTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_weatherIconView withOffset:12];
        [_precipitationTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-50];
        
        [_temperatureTitleLabel autoRemoveConstraintsAffectingView];
        [_temperatureTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_precipitationTitleLabel withOffset:12];
        [_temperatureTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-50];
        
        [_windSpeedTitleLabel autoRemoveConstraintsAffectingView];
        [_windSpeedTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_temperatureTitleLabel withOffset:12];
        [_windSpeedTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-50];
        
        // Stats
        [_precipitationLabel autoRemoveConstraintsAffectingView];
        [_precipitationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_precipitationTitleLabel];
        [_precipitationLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_precipitationTitleLabel];
        [_precipitationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_precipitationTitleLabel withOffset:6];
        
        [_temperatureLabel autoRemoveConstraintsAffectingView];
        [_temperatureLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_temperatureTitleLabel];
        [_temperatureLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_temperatureTitleLabel];
        [_temperatureLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_temperatureTitleLabel withOffset:6];
        
        [_windSpeedLabel autoRemoveConstraintsAffectingView];
        [_windSpeedLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_windSpeedTitleLabel];
        [_windSpeedLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_windSpeedTitleLabel];
        [_windSpeedLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_windSpeedTitleLabel withOffset:6];
        
        // Source
        [_weatherSourceLabel autoRemoveConstraintsAffectingView];
        [_weatherSourceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-35];
        [_weatherSourceLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-2];
        
        [_errorLabel setHidden:true];
    }
    
    [super layoutSubviews];
}



@end
