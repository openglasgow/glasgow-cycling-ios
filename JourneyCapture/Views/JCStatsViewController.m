//
//  JCStatsViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCStatsViewController.h"
#import "JCUserHeaderView.h"
#import "JCUserViewModel.h"

@interface JCStatsViewController ()

@end

@implementation JCStatsViewController

-(id)initWithViewModel:(JCUserViewModel *)userViewModel
{
    self = [super init];
    if (self) {
        _userViewModel = userViewModel;
    }
    return self;
}

# pragma mark - UIViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // User header
    _headerView = [[JCUserHeaderView alloc] initWithViewModel:_userViewModel];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_headerView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_headerView autoRemoveConstraintsAffectingView];
    [_headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_headerView autoSetDimension:ALDimensionHeight toSize:213.0f];
    
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
