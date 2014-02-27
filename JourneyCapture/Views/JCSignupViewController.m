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

    // Nav bar
    [[self navigationItem] setTitle:@"Sign Up"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:nil
                                                                             action:nil];
    RAC(self, navigationItem.rightBarButtonItem.enabled) = self.viewModel.isValidDetails;
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.viewModel signup];
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
    NSLog(@"View loaded");
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
