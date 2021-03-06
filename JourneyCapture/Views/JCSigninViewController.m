//
//  JCSigninViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSigninViewController.h"
#import "JCSigninView.h"
#import "JCResetPasswordView.h"
#import "JCSignupViewController.h"
#import "JCSigninViewModel.h"
#import "JCSignupViewModel.h"
#import "JCResetPasswordViewModel.h"
#import "JCUserViewController.h"
#import "JCResetPasswordViewController.h"
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

#pragma mark - JCSigninViewController
- (RACSignal *)signin
{
    _signinView.loadingView.loading = YES;
    [self dismissKeyboard];
    [[_viewModel signin] subscribeError:^(NSError *error) {
        CLS_LOG(@"User sign in error");
        _signinView.loadingView.loading = NO;
        _signinView.loadingView.infoLabel.text = @"Problem Signing In";
    } completed:^{
        CLS_LOG(@"User sign in success");
        JCUserViewController *userController = [[JCUserViewController alloc] init];
        [self.navigationController pushViewController:userController animated:YES];
    }];
    return [RACSignal empty];
}

#pragma mark - UIViewController

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:frame];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Nav bar
    [[self navigationItem] setTitle:@"Welcome to Go Cycling"];
    
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
    CLS_LOG(@"Sign in VC loaded");
    
    // Sign in
    @weakify(self);
    _signinView.signinButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self signin];
    }];
    
    // Sign up
    _signinView.signupButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSLog(@"Signup tapped");
        CLS_LOG(@"Signup button tapped");
        JCSignupViewModel *signupVM = [JCSignupViewModel new];
        [signupVM setEmail:_viewModel.email];
        JCSignupViewController *signupController = [[JCSignupViewController alloc] initWithViewModel:signupVM];
        [self.navigationController pushViewController:signupController animated:YES];
        return [RACSignal empty];
    }];
    
    // Reset
    _signinView.resetButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        CLS_LOG(@"Reset password tapped");
        JCResetPasswordViewModel *resetVM = [JCResetPasswordViewModel new];
        JCResetPasswordViewController *resetController = [[JCResetPasswordViewController alloc] initWithViewModel:resetVM];
        [self.navigationController pushViewController:resetController animated:YES];
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
    [_signinView endEditing:YES];
    
    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
    [_signinView.contentView setContentOffset:scrollPoint animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat offset = 180;
    CGPoint scrollPoint = CGPointMake(0.0, offset);
    [_signinView.contentView setContentOffset:scrollPoint animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _signinView.emailField) {
        [_signinView.passwordField becomeFirstResponder];
    } else {
        [self signin];
    }
    return YES;
}

@end
