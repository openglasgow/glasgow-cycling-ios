//
//  JCWeatherView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 06/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCWeatherViewModel;

@interface JCWeatherView : UIView

@property (strong, nonatomic) JCWeatherViewModel *viewModel;

@property (strong, nonatomic) UIImageView *weatherIconView;

@property (strong, nonatomic) UILabel *precipitationTitleLabel;
@property (strong, nonatomic) UILabel *precipitationLabel;

@property (strong, nonatomic) UILabel *temperatureTitleLabel;
@property (strong, nonatomic) UILabel *temperatureLabel;

@property (strong, nonatomic) UILabel *windSpeedTitleLabel;
@property (strong, nonatomic) UILabel *windSpeedLabel;

@property (strong, nonatomic) UILabel *weatherSourceLabel;

- (id)initWithViewModel:(JCWeatherViewModel *)weatherViewModel;

@end
