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
#import "JCGraphScrollView.h"

@interface JCStatsViewController ()

@end

CGFloat const kHeaderHeight = 213.0f;

@implementation JCStatsViewController

-(id)initWithViewModel:(JCUserViewModel *)userViewModel
{
    self = [super init];
    if (self) {
        _userViewModel = userViewModel;
        _usageViewModel = [JCUsageViewModel new];
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
    
    // Hint label
    _hintLabel = [UILabel new];
    _hintLabel.textColor = [UIColor whiteColor];
    _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _hintLabel.text = @"Press graph for details";
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_hintLabel];
    
    // Graphs
    CGFloat screenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat graphAreaHeight = screenHeight - navHeight - kHeaderHeight;
    CGFloat graphAreaWidth = 320;
    
    _graphScrollView = [[JCGraphScrollView alloc] initWithFrame:CGRectMake(0, 0, graphAreaWidth, graphAreaHeight)
                                                      viewModel:_usageViewModel];
    _graphScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_graphScrollView];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_headerView autoRemoveConstraintsAffectingView];
    [_headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_headerView autoSetDimension:ALDimensionHeight toSize:kHeaderHeight];
    
    [_hintLabel autoRemoveConstraintsAffectingView];
    [_hintLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_headerView withOffset:-10];
    [_hintLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_headerView];
    [_hintLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_headerView];
    
    [_graphScrollView autoRemoveConstraintsAffectingView];
    [_graphScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_graphScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerView];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Stats"];
    
    [[_usageViewModel loadStatsForDays:7] subscribeError:^(NSError *error) {
        NSLog(@"Couldn't load usage");
    } completed:^{
        NSLog(@"Got usage data");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
