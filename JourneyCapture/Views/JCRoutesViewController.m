//
//  JCRoutesViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRoutesViewController.h"

@interface JCRoutesViewController ()

@end

@implementation JCRoutesViewController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITableView *routesTableView = [[UITableView alloc] init];
    [self.view addSubview:routesTableView];
    [routesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"My Routes"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
