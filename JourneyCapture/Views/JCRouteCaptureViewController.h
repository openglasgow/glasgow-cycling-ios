//
//  JCRouteCaptureViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
#import "JCLocationManager.h"

@class JCCaptureView, JCCaptureViewModel;

@interface JCRouteCaptureViewController : UIViewController <JCLocationManagerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) JCCaptureViewModel *viewModel;
@property (strong, nonatomic) JCCaptureView *captureView;
@property (strong, nonatomic) RACDisposable *alertDisposable;
- (void)startRoute;
- (void)endRoute;
- (void)submitRoute;
- (void)scheduleWarningNotification;
- (void)cancelWarningNotification;
@end
