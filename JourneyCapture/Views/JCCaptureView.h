//
//  JCCaptureView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IFTTTJazzHands.h"
#import <EDStarRating/EDStarRating.h>
@class JCRouteViewModel;

@interface JCCaptureView : UIView <MKMapViewDelegate, EDStarRatingProtocol>
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) MKPolyline *routeLine;
@property (nonatomic, strong) MKPolylineView *routeLineView;
@property (strong, nonatomic) UIButton *captureButton;
@property (strong, nonatomic) UITableView *statsTable;
@property (strong, nonatomic) JCRouteViewModel *viewModel;

// Review
@property (strong, nonatomic) UIScrollView *reviewScrollView;
@property (strong, nonatomic) UILabel *safetyReviewLabel;
@property (strong, nonatomic) EDStarRating *safetyRating;
@property (strong, nonatomic) UILabel *environmentReviewLabel;
@property (strong, nonatomic) EDStarRating *environmentRating;
@property (strong, nonatomic) UILabel *difficultyReviewLabel;
@property (strong, nonatomic) EDStarRating *difficultyRating;
@property (strong, nonatomic) UILabel *reviewCompleteLabel;
@property (strong, nonatomic) UILabel *reviewGuidanceLabel;

@property (strong, nonatomic) IFTTTAnimator *animator;
@property (strong, nonatomic) MASConstraint *mapBottomConstraint;
@property (strong, nonatomic) MASConstraint *statsTopConstraint;
@property (strong, nonatomic) MASConstraint *statsBottomConstraint;
@property (strong, nonatomic) MASConstraint *reviewTopConstraint;
@property (strong, nonatomic) MASConstraint *reviewBottomConstraint;

- (id)initWithFrame:(CGRect)frame viewModel:(JCRouteViewModel *)captureViewModel;
- (void)transitionToActive;
- (void)transitionToComplete;
- (void)updateRouteLine;
@end
