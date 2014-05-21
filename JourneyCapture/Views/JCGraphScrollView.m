//
//  JCGraphScrollView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 21/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCGraphScrollView.h"
#import "JCStatViewModel.h"
#import "JCGraphView.h"
#import "JCBarChartView.h"
#import "JCLineGraphView.h"

@implementation JCGraphScrollView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame viewModel:(JCUsageViewModel *)usageViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    
    _viewModel = usageViewModel;
    
    // Scroll Area
    _statsScrollView = [UIScrollView new];
    _statsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _statsScrollView.pagingEnabled = YES;
    _statsScrollView.showsVerticalScrollIndicator = NO;
    _statsScrollView.showsHorizontalScrollIndicator = NO;
    
    _statsScrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    
    [self addSubview:_statsScrollView];
    
    // Stat VMs
    JCStatViewModel *distanceStatVM = [[JCStatViewModel alloc] initWithUsage:_viewModel
                                                                  displayKey:kStatsDistanceKey
                                                                       title:@"Distance"];
    
    CGFloat graphHeight = frame.size.height - 40; // 40 is space for graph title
    _graphViews = [NSMutableArray new];

    // Bar Chart Distance
    JCBarChartView *barChartDistanceView = [[JCBarChartView alloc] initWithViewModel:distanceStatVM];
    barChartDistanceView.graphView.frame = CGRectMake(0, 0, frame.size.width, graphHeight);
    [barChartDistanceView reloadData];
    barChartDistanceView.translatesAutoresizingMaskIntoConstraints = NO;
    [_graphViews addObject:barChartDistanceView];
    [self.statsScrollView addSubview:barChartDistanceView];
    
    // Line Graph Distance
    JCLineGraphView *lineGraphDistanceView = [[JCLineGraphView alloc] initWithViewModel:distanceStatVM];
    lineGraphDistanceView.graphView.frame = CGRectMake(0, 0, frame.size.width, graphHeight);
    [lineGraphDistanceView reloadData];
    lineGraphDistanceView.translatesAutoresizingMaskIntoConstraints = NO;
    [_graphViews addObject:lineGraphDistanceView];
    [self.statsScrollView addSubview:lineGraphDistanceView];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_statsScrollView autoRemoveConstraintsAffectingView];
    [_statsScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    for (int i = 0; i < _graphViews.count; i++) {
        CGFloat leftOffset = i * 320;
        JCGraphView *graphView = _graphViews[i];
        
        [graphView autoRemoveConstraintsAffectingView];
        [graphView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_statsScrollView withOffset:leftOffset];
        [graphView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_statsScrollView];
        [graphView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_statsScrollView];
        [graphView autoSetDimensionsToSize:CGSizeMake(320, _statsScrollView.contentSize.height)];
        
        if (i == _graphViews.count - 1) {
            [graphView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_statsScrollView];
        }
    }
    
    [super layoutSubviews];
}

@end
