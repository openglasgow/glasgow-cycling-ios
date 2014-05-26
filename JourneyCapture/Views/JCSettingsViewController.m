//
//  JCSettingsViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSettingsViewController.h"
#import "JCSettingsViewController.h"
#import "JCSettingsViewModel.h"
#import "JCSettingsView.h"

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
    
    // Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//- (void)dismissKeyboard
//{
//    [_signupView.passwordField resignFirstResponder];
//    [_signupView.dobField resignFirstResponder];
//    [_signupView.genderField resignFirstResponder];
//    
//    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
//    [_signupView.contentView setContentOffset:scrollPoint animated:YES];
//}

@end
