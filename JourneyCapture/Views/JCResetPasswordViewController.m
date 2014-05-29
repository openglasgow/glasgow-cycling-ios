//
//  JCResetPasswordViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 29/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCResetPasswordViewController.h"
#import "JCResetPasswordView.h"

@interface JCResetPasswordViewController ()

@end

@implementation JCResetPasswordViewController

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
    NSLog(@"Loading view");
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
    
    [_resetView autoRemoveConstraintsAffectingView];
    [_resetView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_resetView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
