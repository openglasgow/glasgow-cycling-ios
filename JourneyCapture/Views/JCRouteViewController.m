//
//  JCRouteViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteViewController.h"
#import "JCRouteViewModel.h"
#import "JCRoutePointViewModel.h"
#import "JCRouteView.h"

@interface JCRouteViewController ()

@end

@implementation JCRouteViewController

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = routeViewModel;
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [UIView new];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _routeView = [[JCRouteView alloc] initWithViewModel:_viewModel];
    _routeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_routeView];
    
    // Load route points
    [[self.viewModel loadPoints] subscribeError:^(NSError *error) {
        NSLog(@"Error loading route points");
    } completed:^{
        NSLog(@"Loaded route points");
        [_routeView drawRoute];
    }];

    [self setTitle:self.viewModel.name];
}

- (void)viewWillLayoutSubviews
{
    [_routeView autoRemoveConstraintsAffectingView];
    [_routeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_routeView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
