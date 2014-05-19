//
//  JCStatsViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCStatsViewController.h"

@interface JCStatsViewController ()

@end

@implementation JCStatsViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

# pragma mark - UIViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    // User details
//    _userView = [[JCUserView alloc] initWithViewModel:_viewModel];
//    _userView.translatesAutoresizingMaskIntoConstraints = NO;
//    _userView.menuTableView.delegate = self;
//    _userView.menuTableView.dataSource = self;
//    [self.view addSubview:_userView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    
//    [_userView autoRemoveConstraintsAffectingView];
//    [_userView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
