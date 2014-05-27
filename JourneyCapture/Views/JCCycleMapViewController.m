//
//  JCCycleMapViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCycleMapViewController.h"
#import "JCCycleMapView.h"
#import "JCCycleMapViewModel.h"

@interface JCCycleMapViewController ()

@end

@implementation JCCycleMapViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [JCCycleMapViewModel new];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cycleMapView = [[JCCycleMapView alloc] initWithViewModel:_viewModel];
    _cycleMapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_cycleMapView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_cycleMapView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_cycleMapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
