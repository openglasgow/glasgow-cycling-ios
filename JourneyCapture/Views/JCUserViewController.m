//
//  JCUserViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserViewController.h"
#import "JCUserViewModel.h"
#import "JCUserView.h"

@interface JCUserViewController ()

@end

@implementation JCUserViewController
@synthesize viewModel;
@synthesize myRoutesButton, nearbyRoutesButton, createRouteButton;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.viewModel = [[JCUserViewModel alloc] init];
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // User details
    JCUserView *detailsView = [[JCUserView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                      viewModel:self.viewModel];
    [self.view addSubview:detailsView];
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    [detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.top.equalTo(self.view.mas_top).with.offset(navBarHeight + 35); // Extra 20 for status bar
        make.bottom.equalTo(detailsView.distanceThisMonthView.mas_bottom).with.offset(15);
    }];
    
    // Route buttons
    self.myRoutesButton = [[UIButton alloc] init];
    [self.myRoutesButton setTitle:@"My Routes" forState:UIControlStateNormal];
    [self.myRoutesButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [self.view addSubview:self.myRoutesButton];
    
    [self.myRoutesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailsView.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.nearbyRoutesButton = [[UIButton alloc] init];
    [self.nearbyRoutesButton setTitle:@"Nearby Routes" forState:UIControlStateNormal];
    [self.nearbyRoutesButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [self.view addSubview:self.nearbyRoutesButton];
    
    [self.nearbyRoutesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myRoutesButton.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.createRouteButton = [[UIButton alloc] init];
    [self.createRouteButton setTitle:@"Create Route" forState:UIControlStateNormal];
    [self.createRouteButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [self.view addSubview:self.createRouteButton];
    
    [self.createRouteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nearbyRoutesButton.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [[self navigationItem] setTitle:self.viewModel.firstName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
