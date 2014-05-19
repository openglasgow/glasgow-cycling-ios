//
//  JCGraphView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCGraphView.h"
#import "JBChartView.h"

@implementation JCGraphView

- (id)initWithViewModel:(JCStatsViewModel *)statsViewModel;
{
    self = [super init];
    if (self) {
        _viewModel = statsViewModel;
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"Graph";
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _graphView = [JBChartView new];
        _graphView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_graphView];
    }
    return self;
}

- (void)redraw
{
    [_graphView reloadData];
}

# pragma mark - UIView

- (void)layoutSubviews
{
    [_titleLabel autoRemoveConstraintsAffectingView];
    [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 0, 0, 0) excludingEdge:ALEdgeBottom];
    
    [_graphView autoRemoveConstraintsAffectingView];
    [_graphView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_graphView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:10];
}

@end
