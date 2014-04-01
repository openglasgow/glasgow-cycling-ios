//
//  JCSigninViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSigninViewController.h"
#import "JCSigninView.h"
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
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    // Nav bar
    [[self navigationItem] setTitle:@"Sign In"];
    [self.navigationController setDelegate:self];

    // Signin button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:nil
                                                                             action:nil];
    RAC(self, navigationItem.rightBarButtonItem.enabled) = _viewModel.isValidDetails;
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signinSignal = [_viewModel signin];
        [signinSignal subscribeNext:^(id x) {
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
    
    // Signin form
    _signinView = [[JCSigninView alloc] initWithViewModel:_viewModel];
    _signinView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_signinView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    double statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    double navBarHeight = self.navigationController.navigationBar.frame.size.height;

    [_signinView autoRemoveConstraintsAffectingView];
    [_signinView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(statusBarHeight + navBarHeight + 10, 10, 10, 10)];

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == navigationController.viewControllers[0]) {
        // Back to welcome view - smooth changing from nav bar to no nav bar
        [navigationController setNavigationBarHidden:YES animated:NO];
    }
}

@end
