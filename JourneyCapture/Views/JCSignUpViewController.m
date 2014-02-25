//
//  JCSignUpViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSignUpViewController.h"
#import "JCSignupViewModel.h"

@interface JCSignUpViewController ()

@end

@implementation JCSignUpViewController
@synthesize viewModel;
@synthesize emailField, passwordField, firstNameField, lastNameField;

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
            NSLog(@"Sign Up tapped");
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    // Form
    int textFieldWidth = 220;
    int textFieldX = self.view.center.x - (textFieldWidth/2);
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, 100, textFieldWidth, 31)];
    [self.emailField setBorderStyle:UITextBorderStyleRoundedRect];
    RAC(self.viewModel, email) = self.emailField.rac_textSignal;
    [self.view addSubview:self.emailField];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, 151, textFieldWidth, 31)];
    [self.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    RAC(self.viewModel, password) = self.passwordField.rac_textSignal;
    [self.view addSubview:self.passwordField];
    
    self.firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, 202, textFieldWidth, 31)];
    [self.firstNameField setBorderStyle:UITextBorderStyleRoundedRect];
    RAC(self.viewModel, firstName) = self.firstNameField.rac_textSignal;
    [self.view addSubview:self.firstNameField];
    
    self.lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, 253, textFieldWidth, 31)];
    [self.lastNameField setBorderStyle:UITextBorderStyleRoundedRect];
    RAC(self.viewModel, lastName) = self.lastNameField.rac_textSignal;
    [self.view addSubview:self.lastNameField];
    
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
