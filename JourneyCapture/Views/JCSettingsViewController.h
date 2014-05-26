//
//  JCSettingsViewController.h
//  JourneyCapture
//
//  Created by Michael Hayes on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCSettingsViewModel, JCSettingsView;

@interface JCSettingsViewController : UIViewController

@property (strong, nonatomic) JCSettingsViewModel *viewModel;
@property (strong, nonatomic) JCSettingsView *settingsView;

- (id)initWithViewModel:(JCSettingsViewModel *)settingsViewModel;

@end
