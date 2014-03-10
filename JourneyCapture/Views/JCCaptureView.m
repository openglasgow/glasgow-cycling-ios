//
//  JCCaptureView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCaptureView.h"
#import <QuartzCore/QuartzCore.h>
#import "JCRouteCaptureViewModel.h"
#import "JCRoutePointViewModel.h"

@implementation JCCaptureView
@synthesize mapview, routeLine, routeLineView, captureButton, statsTable, viewModel;

- (id)initWithFrame:(CGRect)frame viewModel:(JCRouteCaptureViewModel *)captureViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    self.viewModel = captureViewModel;

    // Capture button
    UIColor *buttonColor = [UIColor colorWithRed:0 green:224.0/255.0 blue:184.0/255.0 alpha:1.0];
    CGRect buttonFrame = CGRectMake(22, self.frame.size.height - 75, self.frame.size.width - 44, 50);
    self.captureButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [self.captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.captureButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.captureButton setBackgroundColor:buttonColor];
    self.captureButton.layer.masksToBounds = YES;
    self.captureButton.layer.cornerRadius = 8.0f;
    [self addSubview:self.captureButton];

    // Map view
    self.mapview = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100)];
    self.mapview.layer.masksToBounds = NO;
    self.mapview.layer.shadowOffset = CGSizeMake(0, 1);
    self.mapview.layer.shadowRadius = 2;
    self.mapview.layer.shadowOpacity = 0.5;
    [self addSubview:self.mapview];

    self.mapview.showsUserLocation = YES;
    [self.mapview setDelegate:self];
    [self.mapview setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.mapview setUserInteractionEnabled:NO];

    // Stats
    self.statsTable = [[UITableView alloc] init];
    [self insertSubview:self.statsTable belowSubview:self.mapview];
    [self.statsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.captureButton.mas_top).with.offset(-25);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(self.frame.size.height - 400));
    }];

    return self;
}

- (void)transitionToActive
{
    // Move map and button
    UIColor *stopColor = [UIColor colorWithRed:243.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.mapview.frame = CGRectMake(0, 0, self.frame.size.width, 300);
                         [self.captureButton setTitle:@"Stop" forState:UIControlStateNormal];
                         [self.captureButton setBackgroundColor:stopColor];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Animated to active!");
                     }];
}

- (void)updateRoute
{
    NSUInteger numPoints = [self.viewModel.points count];

    if (numPoints < 2) {
        return;
    }

    JCRoutePointViewModel *point = self.viewModel.points[numPoints-1];
    CLLocationCoordinate2D coord = point.location.coordinate;

    JCRoutePointViewModel *previousPoint = self.viewModel.points[numPoints-2];
    CLLocationCoordinate2D previousCoord = previousPoint.location.coordinate;

    MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
    pointsArray[0]= MKMapPointForCoordinate(previousCoord);
    pointsArray[1]= MKMapPointForCoordinate(coord);

    routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
    free(pointsArray);

    [[self mapview] addOverlay:routeLine];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = self.tintColor;
    renderer.lineWidth = 2.5;
    return  renderer;
}

@end
