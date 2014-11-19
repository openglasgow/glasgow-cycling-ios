//
//  JCResetPasswordViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 29/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCResetPasswordViewController.h"
#import "JCResetPasswordView.h"
#import "JCResetPasswordViewModel.h"
#import "JCTextField.h"
#import "JCNotificationManager.h"

@interface JCResetPasswordViewController ()

@end

@implementation JCResetPasswordViewController

#pragma mark - Lifecycle

- (id)initWithViewModel:(JCResetPasswordViewModel *)resetPasswordViewModel
{
    self = [super init];
    if (self) {
        _viewModel = resetPasswordViewModel;
        NSLog(@"Init reset password controller");
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Nav bar
    [[self navigationItem] setTitle:@"Password Reset"];
    
    // Form
    _resetView = [[JCResetPasswordView alloc] initWithViewModel:_viewModel];
    _resetView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_resetView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_resetView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_resetView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLS_LOG(@"Loaded reset password view");
    
    _resetView.emailField.delegate = self;
    
    [RACObserve(self, viewModel.email) subscribeNext:^(id x) {
        _resetView.emailField.text = _viewModel.email;
    }];
    
    // reset button
    _resetView.resetButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self resetPassword];
        return [RACSignal empty];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JCResetPasswordViewController

- (void)resetPassword
{
    NSLog(@"Password reset pressed");
    _resetView.resetButton.enabled = NO;
    [[_viewModel reset] subscribeError:^(NSError *error) {
        _resetView.resetButton.enabled = YES;
        [_resetView setErrorHidden:NO];
        [_resetView layoutIfNeeded];
        NSLog(@"Couldn't reset");
    } completed:^{
        NSLog(@"Reset password email sent");
        [_resetView setErrorHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [[JCNotificationManager manager] displayInfoWithTitle:@"Instructions Sent" subtitle:@"Password reset instructions have been emailed to you" icon:[UIImage imageNamed:@"mail-sent-icon"]];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resetPassword];
    return YES;
}

@end
