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

#import "JCQuestionViewController.h"
#import "JCQuestionViewModel.h"
#import "JCQuestionListViewModel.h"
#import "Flurry.h"

@interface JCSignupViewController ()

@end

@implementation JCSignupViewController
@synthesize viewModel;
@synthesize signupView;

- (id)init
{
    self = [super init];
    if (self) {
        self.viewModel = [[JCSignupViewModel alloc] init];
        NSLog(@"Init signup controller");
    }
    return self;
}

- (void)loadView
{
    NSLog(@"Loading view");
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setDelegate:self];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    // Nav bar
    [[self navigationItem] setTitle:@"Sign Up"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:nil
                                                                             action:nil];
    [self.view setBackgroundColor:[UIColor colorWithRed:(38.0 / 255.0) green:(224.0 / 255.0) blue:(184.0 / 255.0) alpha: 1]];
    RAC(self, navigationItem.rightBarButtonItem.enabled) = self.viewModel.isValidDetails;
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signupSignal = [self.viewModel signup];
        [signupSignal subscribeNext:^(id x) {
            NSLog(@"Signup::next");
        } error:^(NSError *error) {
            NSLog(@"Signup::error");
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
    
    // Form
    CGRect signupFrame = self.view.frame;
    signupFrame.origin.y = 74;
    self.signupView = [[JCSignupView alloc] initWithFrame:signupFrame viewModel:self.viewModel];
    [self.view addSubview:self.signupView];
    UIView *superview = self.view;
    [self.signupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(74);
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
    }];
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == navigationController.viewControllers[0]) {
        // Back to welcome view
        [navigationController setNavigationBarHidden:YES animated:NO];
    }
}

@end
