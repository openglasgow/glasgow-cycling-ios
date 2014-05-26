//
//  JCStatsSummaryView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 23/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCStatsSummaryView.h"

@implementation JCStatsSummaryView

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    UIFont *statsTitleFont = [UIFont systemFontOfSize:15];
    UIColor *statsTitleColor = [UIColor jc_lightBlueColor];
    UIFont *statsFont = [UIFont boldSystemFontOfSize:32];
    UIColor *statsColor = [UIColor jc_blueColor];
    
    _distanceTitleLabel = [UILabel new];
    _distanceTitleLabel.font = statsTitleFont;
    _distanceTitleLabel.textColor = statsTitleColor;
    _distanceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _distanceTitleLabel.text = @"Distance";
    [self addSubview:_distanceTitleLabel];
    
    _distanceLabel = [UILabel new];
    _distanceLabel.font = statsFont;
    _distanceLabel.textColor = statsColor;
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _distanceLabel.text = @"10 miles";
    [self addSubview:_distanceLabel];
    
    _routesCompletedTitleLabel = [UILabel new];
    _routesCompletedTitleLabel.font = statsTitleFont;
    _routesCompletedTitleLabel.textColor = statsTitleColor;
    _routesCompletedTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _routesCompletedTitleLabel.text = @"Routes";
    [self addSubview:_routesCompletedTitleLabel];
    
    _routesCompletedLabel = [UILabel new];
    _routesCompletedLabel.font = statsFont;
    _routesCompletedLabel.textColor = statsColor;
    _routesCompletedLabel.textAlignment = NSTextAlignmentCenter;
    _routesCompletedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _routesCompletedLabel.text = @"3 routes";
    [self addSubview:_routesCompletedLabel];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_distanceTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
    [_distanceTitleLabel autoConstrainAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeCenterY
                                         ofView:self withOffset:-30];

    [_distanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_distanceTitleLabel withOffset:10];
    [_distanceLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_distanceTitleLabel withOffset:5];
    
    [_routesCompletedTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:20];
    [_routesCompletedTitleLabel autoConstrainAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeCenterY
                                         ofView:self withOffset:30];
    
    [_routesCompletedLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_distanceLabel];
    [_routesCompletedLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_routesCompletedTitleLabel withOffset:5];
    
    [super layoutSubviews];
}

@end
