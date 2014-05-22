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
    _statsScrollView.delegate = self;
    _statsScrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height - 20); // Space for pagecontrol
    [self addSubview:_statsScrollView];
    
    // Stat VMs
    JCStatViewModel *distanceStatVM = [[JCStatViewModel alloc] initWithUsage:_viewModel
                                                                  displayKey:kStatsDistanceKey
                                                                       title:@"Distance"];
    
    JCStatViewModel *routesStatVM = [[JCStatViewModel alloc] initWithUsage:_viewModel
                                                                displayKey:kStatsRoutesCompletedKey
                                                                     title:@"Routes Completed"];
    
    CGFloat graphHeight = frame.size.height - 50; // - space for elements above graph
    _graphViews = [NSMutableArray new];
    
    // Line Graph Distance
    JCLineGraphView *lineGraphDistanceView = [[JCLineGraphView alloc] initWithViewModel:distanceStatVM];
    lineGraphDistanceView.graphView.frame = CGRectMake(0, 0, frame.size.width, graphHeight);
    [lineGraphDistanceView reloadData];
    lineGraphDistanceView.translatesAutoresizingMaskIntoConstraints = NO;
    [_graphViews addObject:lineGraphDistanceView];
    [self.statsScrollView addSubview:lineGraphDistanceView];
    
    // Bar Chart Routes Completed
    JCBarChartView *barChartDistanceView = [[JCBarChartView alloc] initWithViewModel:routesStatVM];
    barChartDistanceView.graphView.frame = CGRectMake(0, 0, frame.size.width, graphHeight);
    [barChartDistanceView reloadData];
    barChartDistanceView.translatesAutoresizingMaskIntoConstraints = NO;
    [_graphViews addObject:barChartDistanceView];
    [self.statsScrollView addSubview:barChartDistanceView];
    
    // Page control
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 1000)];
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _pageControl.numberOfPages = _graphViews.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor jc_lightBlueColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor jc_blueColor];
    _pageControl.userInteractionEnabled = YES;
    [_pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
    
    // Reload graphs on data update
    [RACObserve(self, viewModel.periods) subscribeNext:^(id x) {
        for (JCGraphView *graph in _graphViews) {
            [graph reloadData];
        }
    }];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_pageControl autoRemoveConstraintsAffectingView];
    [_pageControl autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [_pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_pageControl autoSetDimensionsToSize:CGSizeMake(20 * _graphViews.count, 20)];
    
    [_statsScrollView autoRemoveConstraintsAffectingView];
    [_statsScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_statsScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_pageControl];
    
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = floorf(_statsScrollView.contentOffset.x/320);
}

#pragma mark - UIPageControl

- (void)pageChanged
{
    CGFloat xOffset = 320 * _pageControl.currentPage;
    CGRect visibleRect = CGRectMake(xOffset, 0, 320, _statsScrollView.contentSize.height);
    [_statsScrollView scrollRectToVisible:visibleRect
                                 animated:YES];
}

@end
