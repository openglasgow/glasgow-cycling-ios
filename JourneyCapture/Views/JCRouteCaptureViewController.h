//
//  JCRouteCaptureViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLocationManager.h"
#import "JCRouteCaptureViewModel.h"

@class JCCaptureView;

@interface JCRouteCaptureViewController : UIViewController <JCLocationManagerDelegate,
                                                            UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) JCRouteCaptureViewModel *viewModel;
@property (strong, nonatomic) JCCaptureView *captureView;
@end
