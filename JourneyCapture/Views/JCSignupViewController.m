//
//  JCSignupViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSignupViewController.h"
#import "JCSignupViewModel.h"
#import "JCSignupView.h"
#import "JCTextField.h"

#import "JCQuestionViewController.h"
#import "JCQuestionViewModel.h"
#import "JCQuestionListViewModel.h"
#import "Flurry.h"

@interface JCSignupViewController ()

@end

@implementation JCSignupViewController

- (id)initWithViewModel:(JCSignupViewModel *)signupViewModel
{
    self = [super init];
    if (self) {
        _viewModel = signupViewModel;
        NSLog(@"Init signup controller");
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    NSLog(@"Loading view");
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Nav bar
    [[self navigationItem] setTitle:@"Join the city"];
    
    // Form
    _signupView = [[JCSignupView alloc] initWithViewModel:_viewModel];
    _signupView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_signupView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [_signupView autoRemoveConstraintsAffectingView];
    [_signupView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_signupView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [RACObserve(self, viewModel.email) subscribeNext:^(id x) {
         _signupView.emailField.text = _viewModel.email;
    }];
    
    // Sign up button
    _signupView.signupButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signupSignal = [_viewModel signup];
        _signupView.loadingView.loading = YES;
        [signupSignal subscribeNext:^(id x) {
            NSLog(@"Signup::next");
        } error:^(NSError *error) {
            NSLog(@"Signup::error");
            _signupView.loadingView.loading = NO;
        } completed:^{
            NSLog(@"Signup::completed");
            [Flurry logEvent:@"User signup success"];
            JCQuestionListViewModel *questionList = [[JCQuestionListViewModel alloc] init];
            JCQuestionViewController *questionVC = [[JCQuestionViewController alloc] initWithViewModel:questionList
                                                                                         questionIndex:0];
            [self.navigationController pushViewController:questionVC animated:YES];
        }];
        return [RACSignal empty];
    }];

    // Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [_signupView.passwordField resignFirstResponder];
    [_signupView.yobField resignFirstResponder];
    [_signupView.genderField resignFirstResponder];

    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
    [_signupView.contentView setContentOffset:scrollPoint animated:YES];
}

@end
