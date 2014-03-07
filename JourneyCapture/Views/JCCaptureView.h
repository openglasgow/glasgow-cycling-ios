//
//  JCCaptureView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface JCCaptureView : UIView
@property (strong, nonatomic) MKMapView *mapview;
@property (strong, nonatomic) UIButton *captureButton;
@property (strong, nonatomic) UITableView *statsTable;

- (void)transitionToActive;
@end
