//
//  JCRouteViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteViewController.h"
#import "JCRouteViewModel.h"
#import "JCRouteSummaryView.h"

@interface JCRouteViewController ()

@end

@implementation JCRouteViewController
@synthesize viewModel, routeImageView, mapImageView;

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.viewModel = routeViewModel;
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    JCRouteSummaryView *routeSummary = [[JCRouteSummaryView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                       viewModel:self.viewModel];
    [self.view addSubview:routeSummary];
    
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    [routeSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(navBarHeight + 35); // 20 for status bar
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.bottom.equalTo(routeSummary.environmentView.mas_bottom).with.offset(15);
    }];
    
    // Background route image view
    UIImage *routeImage = self.viewModel.routeImage;
    self.routeImageView = [[UIImageView alloc] initWithImage:routeImage];
    [self.view insertSubview:self.routeImageView belowSubview:routeSummary];
    [self.routeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@(257.5)); // TODO dynamic - FIX issue with this moving firstNameField
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    // Background map image view
    UIImage *mapImage = [UIImage imageNamed:@"map-hope-science"];
    self.mapImageView = [[UIImageView alloc] initWithImage:mapImage];
    [self.view addSubview:self.mapImageView];
    [self.mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.routeImageView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self setTitle:self.viewModel.name];
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
