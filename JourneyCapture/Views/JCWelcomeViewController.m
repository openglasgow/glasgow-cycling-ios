//
//  JCWelcomeViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCWelcomeViewController.h"
#import "JCWelcomeView.h"
#import "JCSigninViewController.h"
#import "JCSignupViewController.h"
#import "Flurry.h"

@interface JCWelcomeViewController ()

@end

@implementation JCWelcomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[self navigationController] setNavigationBarHidden:YES];

    // Signin & Signup
    JCWelcomeView *welcomeView = [[JCWelcomeView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    UIView *superview = self.view;
    [self.view addSubview:welcomeView];

    [welcomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(74);
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
    }];

    // Actions
    welcomeView.signinButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Signin tapped");
        [Flurry logEvent:@"Signin button tapped"];
        JCSigninViewController *signinController = [[JCSigninViewController alloc] init];
        [self.navigationController pushViewController:signinController animated:YES];
        return [RACSignal empty];
    }];
    
    welcomeView.signupButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Signup tapped");
        [Flurry logEvent:@"Signup button tapped"];
        JCSignupViewController *signupController = [[JCSignupViewController alloc] init];
        [self.navigationController pushViewController:signupController animated:YES];
        return [RACSignal empty];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
