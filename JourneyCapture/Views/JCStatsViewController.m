//
//  JCStatsViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCStatsViewController.h"

#import "JCUserViewModel.h"
#import "JCUsageViewModel.h"
#import "JCStatViewModel.h"

#import "JCUserHeaderView.h"
#import "JCGraphView.h"
#import "JCBarChartView.h"
#import "JCLineGraphView.h"
#import "JCPieChartView.h"

@interface JCStatsViewController ()

@end

CGFloat const kHeaderHeight = 213.0f;

@implementation JCStatsViewController

-(id)initWithViewModel:(JCUserViewModel *)userViewModel
{
    self = [super init];
    if (self) {
        _userViewModel = userViewModel;
        _graphViews = [NSMutableArray new];
    }
    return self;
}

#pragma mark - UIViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // User header
    _headerView = [[JCUserHeaderView alloc] initWithViewModel:_userViewModel];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_headerView];
    
    // TODO graph view paginated scrollview
    _statsScrollView = [UIScrollView new];
    _statsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _statsScrollView.pagingEnabled = YES;
    _statsScrollView.showsVerticalScrollIndicator = NO;
    _statsScrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat screenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat graphAreaHeight = screenHeight - navHeight - kHeaderHeight;
    CGFloat graphAreaWidth = 320;
    _statsScrollView.contentSize = CGSizeMake(graphAreaWidth, graphAreaHeight);
    
    [self.view addSubview:_statsScrollView];
    
    // Stat VMs
    JCUsageViewModel *usageVM = [JCUsageViewModel new];
    JCStatViewModel *distanceStatVM = [[JCStatViewModel alloc] initWithUsage:usageVM
                                                                  displayKey:kStatsDistanceKey
                                                                       title:@"Distance"];
    
    CGFloat graphHeight = graphAreaHeight - 40; // 40 is space for graph title
    
    // Bar Chart Distance
    JCBarChartView *barChartDistanceView = [[JCBarChartView alloc] initWithViewModel:distanceStatVM];
    barChartDistanceView.graphView.frame = CGRectMake(0, 0, graphAreaWidth, graphHeight);
    [barChartDistanceView reloadData];
    barChartDistanceView.translatesAutoresizingMaskIntoConstraints = NO;
    [_graphViews addObject:barChartDistanceView];
    [self.statsScrollView addSubview:barChartDistanceView];
    
    // Line Graph Distance
    JCLineGraphView *lineGraphDistanceView = [[JCLineGraphView alloc] initWithViewModel:distanceStatVM];
    lineGraphDistanceView.graphView.frame = CGRectMake(0, 0, graphAreaWidth, graphHeight);
    [lineGraphDistanceView reloadData];
    lineGraphDistanceView.translatesAutoresizingMaskIntoConstraints = NO;
    [_graphViews addObject:lineGraphDistanceView];
    [self.statsScrollView addSubview:lineGraphDistanceView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_headerView autoRemoveConstraintsAffectingView];
    [_headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_headerView autoSetDimension:ALDimensionHeight toSize:kHeaderHeight];
    
    [_statsScrollView autoRemoveConstraintsAffectingView];
    [_statsScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_statsScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerView];
    
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
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Stats"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
