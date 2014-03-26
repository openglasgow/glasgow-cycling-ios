//
//  JCRouteCaptureViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLocationManager.h"
#import "JCRouteViewModel.h"

@class JCCaptureView;

@interface JCRouteCaptureViewController : UIViewController <JCLocationManagerDelegate, UIAlertViewDelegate,
                                                            UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSDate *captureStart;
@property (strong, nonatomic) JCRouteViewModel *viewModel;
@property (strong, nonatomic) JCCaptureView *captureView;
@property (readwrite, nonatomic) BOOL routeUploaded;
@property (readwrite, nonatomic) BOOL reviewUploaded;
- (void)upload;
- (void)scheduleWarningNotification;
@end
