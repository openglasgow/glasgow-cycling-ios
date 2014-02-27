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

@interface JCSigninViewController ()

@end

@implementation JCSigninViewController
@synthesize viewModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewModel = [[JCSigninViewModel alloc] init];
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Nav bar
    [[self navigationItem] setTitle:@"Sign In"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign In"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:nil
                                                                             action:nil];
    RAC(self, navigationItem.rightBarButtonItem.enabled) = self.viewModel.isValidDetails;
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signinSignal = [self.viewModel signin];
        [signinSignal subscribeNext:^(id x) {
            NSLog(@"Login::next");
        } error:^(NSError *error) {
            NSLog(@"Login::error");
        } completed:^{
            NSLog(@"Login::completed");
        }];
        return [RACSignal empty];
    }];
    
    // Form
    CGRect signinFrame = self.view.frame;
    signinFrame.origin.y = 74;
    UIView *signinView = [[JCSigninView alloc] initWithFrame:signinFrame viewModel:self.viewModel];
    [self.view addSubview:signinView];
    UIView *superview = self.view;
    [signinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(74);
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
