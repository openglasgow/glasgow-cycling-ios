//
//  JCCaptureView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCaptureView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JCCaptureView
@synthesize mapview, captureButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    UIColor *buttonColor = [UIColor colorWithRed:0 green:224.0/255.0 blue:184.0/255.0 alpha:1.0];
    CGRect buttonFrame = CGRectMake(22, self.frame.size.height - 75, self.frame.size.width - 44, 50);
    self.captureButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [self.captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.captureButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.captureButton setBackgroundColor:buttonColor];
    self.captureButton.layer.masksToBounds = YES;
    self.captureButton.layer.cornerRadius = 8.0f;
    [self addSubview:self.captureButton];

    self.mapview = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100)];
    self.mapview.layer.masksToBounds = NO;
    self.mapview.layer.shadowOffset = CGSizeMake(0, 1);
    self.mapview.layer.shadowRadius = 2;
    self.mapview.layer.shadowOpacity = 0.5;
    [self addSubview:self.mapview];

    self.mapview.showsUserLocation = YES;
    [self.mapview setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
