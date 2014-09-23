//
//  JCUserView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import QuartzCore;

#import "JCUserViewModel.h"
#import "JCWeatherViewModel.h"

#import "JCUserView.h"
#import "JCUserHeaderView.h"
#import "JCScrollView.h"
#import "JCWeatherView.h"


@implementation JCUserView

- (id)initWithViewModel:(JCUserViewModel *)userViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = userViewModel;
    self.backgroundColor = [UIColor whiteColor];
    
    // Scroll
    _scrollView = [JCScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
    // Pulldown area
    JCWeatherViewModel *weatherVM = [JCWeatherViewModel new];
    _pulldownView = [[JCWeatherView alloc] initWithViewModel:weatherVM];
    _pulldownView.translatesAutoresizingMaskIntoConstraints = NO;
    _pulldownView.backgroundColor = [UIColor jc_lightBlueColor];
    [_scrollView addSubview:_pulldownView];
    
    // Header
    _headerView = [[JCUserHeaderView alloc] initWithViewModel:_viewModel];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_headerView];
    
    // Capture area
    _mapView = [MKMapView new];
    _mapView.zoomEnabled = NO;
    _mapView.scrollEnabled = NO;
    _mapView.rotateEnabled = NO;
    _mapView.pitchEnabled = NO;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_mapView];
    
    _captureButton = [UIButton new];
    _captureButton.translatesAutoresizingMaskIntoConstraints = NO;
    _captureButton.layer.masksToBounds = YES;
    _captureButton.layer.cornerRadius = 33.75f;
    [_scrollView addSubview:_captureButton];

    UIImage *captureImage = [UIImage imageNamed:@"capture-button"];
    UIImage *captureTappedImage = [UIImage imageNamed:@"capture-button-tapped"];
    [_captureButton setImage:captureImage forState:UIControlStateNormal];
    [_captureButton setImage:captureTappedImage forState:UIControlStateHighlighted];
    
    // Menu area
    _menuTableView = [UITableView new];
    _menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_menuTableView];
    
    // Hide separators between empty cells
    _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    // Scroll
    [_scrollView autoRemoveConstraintsAffectingView];
    [_scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    // Pulldown area
    [_pulldownView autoRemoveConstraintsAffectingView];
    [_pulldownView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView];
    [_pulldownView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_scrollView];
    [_pulldownView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView withOffset:-1000.0f];
    [_pulldownView autoSetDimension:ALDimensionHeight toSize:1000.0f];
    
    // User Header
    [_headerView autoRemoveConstraintsAffectingView];
    [_headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_headerView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scrollView];
    [_headerView autoSetDimension:ALDimensionHeight toSize:213.0f];
    [_headerView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    
    // Capture
    [_mapView autoRemoveConstraintsAffectingView];
    [_mapView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerView];
    [_mapView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_scrollView];
    [_mapView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_scrollView];
    [_mapView autoSetDimension:ALDimensionHeight toSize:128];
    
    [_captureButton autoRemoveConstraintsAffectingView];
    [_captureButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_captureButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_mapView withOffset:15];
    [_captureButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_mapView withOffset:-15];
    [_captureButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_captureButton];

    // Menu
    [_menuTableView autoRemoveConstraintsAffectingView];
    [_menuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_menuTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mapView];
    [_menuTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];

    [super layoutSubviews];
}

@end
