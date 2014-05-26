//
//  JCSettingsViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSettingsViewController.h"
#import "JCUserViewController.h"
#import "JCSettingsViewModel.h"
#import "JCSettingsView.h"
#import "Flurry.h"

@interface JCSettingsViewController ()

@end

@implementation JCSettingsViewController

- (id)initWithViewModel:(JCSettingsViewModel *)settingsViewModel
{
    self = [super init];
    if (self) {
        _viewModel = settingsViewModel;
        NSLog(@"Init settings controller");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController

- (void)loadView
{
    NSLog(@"Loading view");
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Nav bar
    [[self navigationItem] setTitle:@"Update Profile"];
    
    // Form
    _settingsView = [[JCSettingsView alloc] initWithViewModel:_viewModel];
    _settingsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_settingsView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_settingsView autoRemoveConstraintsAffectingView];
    [_settingsView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_settingsView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sign in
    @weakify(self);
    _settingsView.submitButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[_viewModel submit] subscribeNext:^(id x) {
            NSLog(@"Login::next");
        } error:^(NSError *error) {
            NSLog(@"Login::error");
        } completed:^{
            NSLog(@"Login::completed");
            [Flurry logEvent:@"User signin success"];
            JCUserViewController *userController = [[JCUserViewController alloc] init];
            [self.navigationController pushViewController:userController animated:YES];
        }];
        return [RACSignal empty];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
