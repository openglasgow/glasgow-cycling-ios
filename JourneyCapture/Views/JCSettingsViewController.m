//
//  JCSettingsViewController.m
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSettingsViewController.h"
#import "JCSettingsViewModel.h"
#import "JCPasswordViewModel.h"
#import "JCSettingsView.h"
#import "JCSigninViewController.h"
#import "JCPasswordViewController.h"
#import "Flurry.h"
#import "JCUserManager.h"
#import "User.h"

@interface JCSettingsViewController ()

@end

@implementation JCSettingsViewController

- (id)initWithViewModel:(JCSettingsViewModel *)settingsViewModel
{
    self = [super init];
    if (self) {
        _viewModel = settingsViewModel;
        NSLog(@"Init settings controller");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController

- (void)loadView
{
    NSLog(@"Loading settings view");
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Nav bar
    [[self navigationItem] setTitle:@"Update Profile"];
    
    // Form
    _settingsView = [[JCSettingsView alloc] initWithViewModel:_viewModel];
    _settingsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_settingsView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_settingsView autoRemoveConstraintsAffectingView];
    [_settingsView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_settingsView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Profile pic select
    _takeController = [FDTakeController new];
    _takeController.delegate = self;
    _takeController.allowsEditingPhoto = YES;
    UIImagePickerController *imagePicker = _takeController.imagePicker;
    [imagePicker.navigationBar setBarTintColor:[UIColor jc_blueColor]];
    [imagePicker.navigationBar setTranslucent:NO];
    imagePicker.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                                forKey:NSForegroundColorAttributeName];
    _settingsView.profilePictureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [Flurry logEvent:@"Signup profile picture selected"];
        [_takeController takePhotoOrChooseFromLibrary];
        return [RACSignal empty];
    }];
    
    // Sign in
    @weakify(self);
    _settingsView.submitButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[_viewModel submit] subscribeError:^(NSError *error) {
            NSLog(@"Login::error");
        } completed:^{
            NSLog(@"Login::completed");
            [Flurry logEvent:@"User settings change success"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return [RACSignal empty];
    }];
    
    _settingsView.passwordButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        JCPasswordViewModel *passwordVM = [JCPasswordViewModel new];
        JCPasswordViewController *passwordVC = [[JCPasswordViewController alloc] initWithViewModel:passwordVM];
        [self.navigationController pushViewController:passwordVC animated:YES];
        
        return [RACSignal empty];
    }];
    
    _settingsView.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [[JCUserManager sharedManager] logout];
        return [RACSignal empty];
    }];
    
    // Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:_settingsView action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - FDTakeControllerDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    _viewModel.profilePic = photo;
}

@end
