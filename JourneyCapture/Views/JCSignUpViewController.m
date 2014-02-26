//
//  JCSignUpViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSignUpViewController.h"
#import "JCSignupViewModel.h"
#import "JCSignupView.h"

@interface JCSignUpViewController ()

@end

@implementation JCSignUpViewController
@synthesize viewModel;
@synthesize signupView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    // Nav bar
    [[self navigationItem] setTitle:@"Sign Up"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:nil
                                                                             action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self.viewModel signup];
            [subscriber sendCompleted];
            return nil;
        }];
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
    
    RAC(self, navigationItem.rightBarButtonItem.enabled) = self.viewModel.isValidDetails;
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
