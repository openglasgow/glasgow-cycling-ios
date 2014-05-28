//
//  JCPasswordViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPasswordViewController.h"
#import "JCPasswordView.h"
#import "Flurry.h"

@interface JCPasswordViewController ()

@end

@implementation JCPasswordViewController

- (id)initWithViewModel:(JCPasswordViewModel *)passwordViewModel
{
    self = [super init];
    if (self) {
        _viewModel = passwordViewModel;
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
    [[self navigationItem] setTitle:@"Change Password"];
    
    // Form
    _passwordView = [[JCPasswordView alloc] initWithViewModel:_viewModel];
    _passwordView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_passwordView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_passwordView autoRemoveConstraintsAffectingView];
    [_passwordView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_passwordView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sign in
    @weakify(self);
    _passwordView.submitButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[_viewModel submit] subscribeError:^(NSError *error) {
            NSLog(@"Login::error");
        } completed:^{
            NSLog(@"Login::completed");
            [Flurry logEvent:@"User password change success"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return [RACSignal empty];
    }];
    
    _passwordView.resetButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[_viewModel reset] subscribeError:^(NSError *error) {
            NSLog(@"Login::error");
        } completed:^{
            NSLog(@"Login::completed");
            [Flurry logEvent:@"User password change success"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return [RACSignal empty];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


@end
