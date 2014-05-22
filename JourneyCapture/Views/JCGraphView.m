//
//  JCGraphView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCGraphView.h"
#import "JBChartView.h"
#import "JCStatViewModel.h"

@implementation JCGraphView

- (id)initWithViewModel:(JCStatViewModel *)statsViewModel;
{
    self = [super init];
    if (self) {
        _viewModel = statsViewModel;
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor jc_darkGrayColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _viewModel.title;
        [self addSubview:_titleLabel];
        
        _graphView = [JBChartView new];
        _graphView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_graphView];
    }
    return self;
}

- (void)reloadData
{
    [_graphView reloadData];
}

- (void)resetText
{
    _titleLabel.text = _viewModel.title;
}

#pragma mark - UIView

- (void)layoutSubviews
{    
    [_titleLabel autoRemoveConstraintsAffectingView];
    [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_titleLabel autoSetDimension:ALDimensionWidth toSize:320];
    
    [_graphView autoRemoveConstraintsAffectingView];
    [_graphView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_graphView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:10];
    
    [super layoutSubviews];
}

@end
