//
//  JCSigninViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSigninViewController.h"
#import "JCSigninView.h"
#import "JCSignupViewController.h"
#import "JCSigninViewModel.h"
#import "JCUserViewController.h"
#import "Flurry.h"
#import "JCTextField.h"

@interface JCSigninViewController ()

@end

@implementation JCSigninViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [[JCSigninViewModel alloc] init];
    }
    return self;
}

#pragma mark - UIViewController

-(void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:frame];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Nav bar
    [[self navigationItem] setTitle:@"Welcome to Go Cycling"];

    // Signin button
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In"
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:nil
//                                                                             action:nil];
   // RAC(self, navigationItem.rightBarButtonItem.enabled) = _viewModel.isValidDetails;
    
    // Signin form
    _signinView = [[JCSigninView alloc] initWithFrame:frame viewModel:_viewModel];
    _signinView.translatesAutoresizingMaskIntoConstraints = NO;
    _signinView.emailField.delegate = self;
    _signinView.passwordField.delegate = self;
    [self.view addSubview:_signinView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [_signinView autoRemoveConstraintsAffectingView];
    [_signinView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_signinView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sign in
    @weakify(self);
    _signinView.signinButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        _signinView.loadingView.loading = YES;
        @strongify(self);
        [self dismissKeyboard];
        [[_viewModel signin] subscribeNext:^(id x) {
            NSLog(@"Login::next");
        } error:^(NSError *error) {
            NSLog(@"Login::error");
            _signinView.loadingView.loading = NO;
            _signinView.loadingView.infoLabel.text = @"Problem Signing in?";

        } completed:^{
            NSLog(@"Login::completed");
            [Flurry logEvent:@"User signin success"];
            JCUserViewController *userController = [[JCUserViewController alloc] init];
            [self.navigationController pushViewController:userController animated:YES];
        }];
        return [RACSignal empty];
    }];
    
    // Sign up
    _signinView.signupButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Signup tapped");
        [Flurry logEvent:@"Signup button tapped"];
        JCSignupViewController *signupController = [[JCSignupViewController alloc] init];
        [self.navigationController pushViewController:signupController animated:YES];
        return [RACSignal empty];
    }];
    
    // Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [_signinView.emailField resignFirstResponder];
    [_signinView.passwordField resignFirstResponder];
    
    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
    [_signinView.contentView setContentOffset:scrollPoint animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat offset = 213;
    CGPoint scrollPoint = CGPointMake(0.0, offset);
    [_signinView.contentView setContentOffset:scrollPoint animated:YES];
}

@end
