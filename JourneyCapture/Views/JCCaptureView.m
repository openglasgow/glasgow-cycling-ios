//
//  JCCaptureView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCaptureView.h"
#import <QuartzCore/QuartzCore.h>
#import "JCRouteViewModel.h"
#import "JCRoutePointViewModel.h"

@implementation JCCaptureView
@synthesize mapView, routeLine, routeLineView, captureButton, statsTable, viewModel,
            reviewScrollView, safetyRating, safetyReviewLabel, environmentRating, environmentReviewLabel,
            difficultyRating, difficultyReviewLabel, animator, reviewBottomConstraint, reviewTopConstraint,
            mapBottomConstraint, statsTopConstraint, statsBottomConstraint;

- (id)initWithFrame:(CGRect)frame viewModel:(JCRouteViewModel *)captureViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    self.viewModel = captureViewModel;
    self.animator = [IFTTTAnimator new];

    // Capture button
    UIColor *buttonColor = [UIColor colorWithRed:0 green:224.0/255.0 blue:184.0/255.0 alpha:1.0];
    self.captureButton = [[UIButton alloc] init];
    [self.captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.captureButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.captureButton setBackgroundColor:buttonColor];
    self.captureButton.layer.masksToBounds = YES;
    self.captureButton.layer.cornerRadius = 8.0f;
    [self addSubview:self.captureButton];

    [self.captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-25);
        make.top.equalTo(self.mas_bottom).with.offset(-75);
        make.left.equalTo(self).with.offset(22);
        make.right.equalTo(self).with.offset(-22);
    }];

    // Map view
    self.mapView = [[MKMapView alloc] init];
    self.mapView.layer.masksToBounds = NO;
    self.mapView.layer.shadowOffset = CGSizeMake(0, 1);
    self.mapView.layer.shadowRadius = 2;
    self.mapView.layer.shadowOpacity = 0.5;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.mapView.zoomEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.userInteractionEnabled = NO;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.mapView];

    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        self.mapBottomConstraint = make.bottom.equalTo(self.mas_bottom).with.offset(-100);
    }];

    // Stats
    self.statsTable = [[UITableView alloc] init];
    [self insertSubview:self.statsTable belowSubview:self.mapView];
    [self.statsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        self.statsBottomConstraint = make.bottom.equalTo(self.captureButton.mas_top).with.offset(-25);
        make.left.equalTo(self);
        make.right.equalTo(self);
        self.statsTopConstraint = make.top.equalTo(self.captureButton.mas_top).with.offset(-85);
    }];

    // Review elements
    int scrollHeight = 100;
    self.reviewScrollView = [[UIScrollView alloc] init];//]WithFrame:CGRectMake(0, self.frame.size.height,
//                                                                              self.frame.size.width, 100)];
    self.reviewScrollView.contentSize = CGSizeMake(self.frame.size.width * 4, self.reviewScrollView.frame.size.height);
    self.reviewScrollView.pagingEnabled = YES;
    self.reviewScrollView.showsHorizontalScrollIndicator = NO;
    self.reviewScrollView.contentSize = CGSizeMake(self.reviewScrollView.contentSize.width, scrollHeight);
    [self addSubview:self.reviewScrollView];
    [self.reviewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.reviewTopConstraint = make.top.equalTo(self.mas_bottom);
        self.reviewBottomConstraint = make.bottom.equalTo(self.mas_bottom).with.offset(scrollHeight);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];

    double labelY = 20;
    double labelHeight = 21;
    double ratingY = self.safetyReviewLabel.frame.origin.y + labelHeight + 20;
    double ratingWidth = 100;
    double ratingX = (self.frame.size.width/2) - (ratingWidth/2);
    double ratingHeight = 30;

    // Guidance
    self.reviewGuidanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ratingY + ratingHeight + 10, self.frame.size.width, labelHeight)];
    [self.reviewGuidanceLabel setText:@"Tap to review"];
    [self.reviewGuidanceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.reviewScrollView addSubview:self.reviewGuidanceLabel];

    // Animate review guidance label with scroll
    IFTTTFrameAnimation *frameAnimation = [IFTTTFrameAnimation new];
    frameAnimation.view = self.reviewGuidanceLabel;
    [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:0
                                                                    andFrame:CGRectMake(0,
                                                                                        ratingY + ratingHeight + 10,
                                                                                        self.frame.size.width, labelHeight)]];
    [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:self.frame.size.width
                                                                    andFrame:CGRectMake(self.frame.size.width,
                                                                                        ratingY + ratingHeight + 10,
                                                                                        self.frame.size.width, labelHeight)]];
    [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:self.frame.size.width*2
                                                                    andFrame:CGRectMake(self.frame.size.width*2,
                                                                                        ratingY + ratingHeight + 10,
                                                                                        self.frame.size.width, labelHeight)]];
    [self.animator addAnimation:frameAnimation];

    [RACObserve(self.reviewScrollView, contentOffset) subscribeNext:^(NSValue *value) {
        NSInteger x = floor(self.reviewScrollView.contentOffset.x);
        [self.animator animate:x];
    }];

    // Safety rating
    self.safetyReviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, self.frame.size.width, labelHeight)];
    [self.safetyReviewLabel setText:@"Safety Rating"];
    [self.safetyReviewLabel setTextAlignment:NSTextAlignmentCenter];
    [self.reviewScrollView addSubview:self.safetyReviewLabel];

    self.safetyRating = [[EDStarRating alloc] initWithFrame:CGRectMake(ratingX, ratingY, ratingWidth, ratingHeight)];
    [self.safetyRating setEditable:YES];
    [self.safetyRating setDisplayMode:EDStarRatingDisplayFull];
    self.safetyRating.starImage = [UIImage imageNamed:@"star-template"];
    self.safetyRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [self.safetyRating setBackgroundColor:[UIColor clearColor]];
    self.safetyRating.horizontalMargin = 5;
    [self.safetyRating setDelegate:self];
    RACChannelTo(self.safetyRating, rating) = RACChannelTo(self.viewModel, safetyRating);
    [self.reviewScrollView addSubview:self.safetyRating];

    // Environment rating
    self.environmentReviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, labelY, self.frame.size.width, labelHeight)];
    [self.environmentReviewLabel setText:@"Environment Rating"];
    [self.environmentReviewLabel setTextAlignment:NSTextAlignmentCenter];
    [self.reviewScrollView addSubview:self.environmentReviewLabel];

    self.environmentRating = [[EDStarRating alloc] initWithFrame:CGRectMake(ratingX + self.frame.size.width, ratingY, ratingWidth, ratingHeight)];
    [self.environmentRating setEditable:YES];
    [self.environmentRating setDisplayMode:EDStarRatingDisplayFull];
    self.environmentRating.starImage = [UIImage imageNamed:@"star-template"];
    self.environmentRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [self.environmentRating setBackgroundColor:[UIColor clearColor]];
    self.environmentRating.horizontalMargin = 5;
    [self.environmentRating setDelegate:self];
    RACChannelTo(self.environmentRating, rating) = RACChannelTo(self.viewModel, environmentRating);
    [self.reviewScrollView addSubview:self.environmentRating];

    // Difficulty rating
    self.difficultyReviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*2, labelY, self.frame.size.width, labelHeight)];
    [self.difficultyReviewLabel setText:@"Difficulty Rating"];
    [self.difficultyReviewLabel setTextAlignment:NSTextAlignmentCenter];
    [self.reviewScrollView addSubview:self.difficultyReviewLabel];

    self.difficultyRating = [[EDStarRating alloc] initWithFrame:CGRectMake(ratingX + (self.frame.size.width * 2), ratingY, ratingWidth, ratingHeight)];
    [self.difficultyRating setEditable:YES];
    [self.difficultyRating setDisplayMode:EDStarRatingDisplayFull];
    self.difficultyRating.starImage = [UIImage imageNamed:@"star-template"];
    self.difficultyRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [self.difficultyRating setBackgroundColor:[UIColor clearColor]];
    self.difficultyRating.horizontalMargin = 5;
    [self.difficultyRating setDelegate:self];
    RACChannelTo(self.difficultyRating, rating) = RACChannelTo(self.viewModel, difficultyRating);
    [self.reviewScrollView addSubview:self.difficultyRating];

    // Review complete
    self.reviewCompleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*3, (self.reviewScrollView.frame.size.height/2) - labelHeight,
                                                                         self.frame.size.width, labelHeight)];
    [self.reviewCompleteLabel setText:@"Review completed! Please submit"];
    [self.reviewCompleteLabel setTextAlignment:NSTextAlignmentCenter];
    [self.reviewScrollView addSubview:self.reviewCompleteLabel];

    return self;
}

- (void)transitionToActive
{
    // Move map and button
    [self.mapBottomConstraint uninstall];
    [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.mapBottomConstraint = make.bottom.equalTo(self.captureButton.mas_top).with.offset(-self.frame.size.height/3.7);
    }];

    [self.statsTopConstraint uninstall];
    [self.statsTable mas_updateConstraints:^(MASConstraintMaker *make) {
        self.statsTopConstraint = make.top.equalTo(self.mapView.mas_bottom);
    }];

    UIColor *stopColor = [UIColor colorWithRed:243.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.mapView layoutIfNeeded];
                         [self.statsTable layoutIfNeeded];
                         [self.captureButton setTitle:@"Stop" forState:UIControlStateNormal];
                         [self.captureButton setBackgroundColor:stopColor];
                         [self.statsTable reloadData];
                     }
                     completion:^(BOOL finished){
                         // Adjusting map can stop tracking
                         [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
                     }];
}

- (void)transitionToComplete
{
    // Hide user location
    [self.mapView setShowsUserLocation:NO];

    // Calculate map area in which route is held
    MKMapRect zoomRect = MKMapRectNull;
    for (JCRoutePointViewModel *point in self.viewModel.points)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(point.location.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 150.0, 150.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }

    // Add area to top of rect to prevent navbar covering route
    MKMapRect topRect = MKMapRectMake(zoomRect.origin.x, zoomRect.origin.y + (zoomRect.size.width/2) - 500,
                                      zoomRect.size.width, 500);
    zoomRect = MKMapRectUnion(zoomRect, topRect);

    // Update positions
    [self.mapBottomConstraint uninstall];
    [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.mapBottomConstraint = make.bottom.equalTo(self.captureButton.mas_top).with.offset(-self.frame.size.height/2.5);
    }];

    double statsHeight = self.statsTable.frame.size.height;
    double tableOffset = statsHeight - (2 * [self.statsTable rowHeight]);
    [self.statsTopConstraint uninstall];
    [self.statsBottomConstraint uninstall];
    [self.statsTable mas_updateConstraints:^(MASConstraintMaker *make) {
        self.statsTopConstraint = make.top.equalTo(self.mapView.mas_bottom).with.offset(-(statsHeight/3));
        self.statsBottomConstraint = make.bottom.equalTo(self.mapView.mas_bottom).with.offset(2*(statsHeight/3));
    }];

    double statsBottom = 200 - tableOffset + self.statsTable.frame.size.height;
    self.reviewScrollView.frame = CGRectMake(0, statsBottom + 25,
                                             self.frame.size.width, self.reviewScrollView.frame.size.height);

    [self.reviewTopConstraint uninstall];
    [self.reviewBottomConstraint uninstall];
    [self.reviewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.reviewTopConstraint = make.top.equalTo(self.statsTable.mas_bottom).with.offset(10);
        self.reviewBottomConstraint = make.bottom.equalTo(self.statsTable.mas_bottom).with.offset(110);
    }];

    // Slide stats and review view up
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Shrink map, hide current speed
                         [self.mapView layoutIfNeeded];
                         [self.statsTable layoutIfNeeded];

                         // Show review scrollview
                         [self.reviewScrollView layoutIfNeeded];
                         self.reviewScrollView.contentSize = CGSizeMake(self.frame.size.width * 4, self.reviewScrollView.frame.size.height);

                         // Submit button
                         [self.captureButton setTitle:@"Submit" forState:UIControlStateNormal];
                         [self.captureButton setBackgroundColor:self.tintColor];
                     }
                     completion:^(BOOL finished){
                         // Show entire route
                         [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
                         [self.mapView setVisibleMapRect:zoomRect animated:YES];
                     }];
}

- (void)updateRouteLine
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

    [[self mapView] addOverlay:routeLine];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = self.tintColor;
    renderer.lineWidth = 2.5;
    return  renderer;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Ensure mapview is zoomed in to a reasonable amount when user location is found
    // (seems to be an issue with mapView userTrackingEnabled where this sometimes doesn't happen)
    MKCoordinateSpan zoomSpan = self.mapView.region.span;
    if (zoomSpan.latitudeDelta > 1 || zoomSpan.longitudeDelta > 1) {
        // 1 might be a bit large, but delta is typically initially ~50-55
        CLLocationCoordinate2D loc = [userLocation coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    // Show next review
    CGRect nextReviewRect = CGRectMake(self.reviewScrollView.contentOffset.x,
                                       self.reviewScrollView.contentOffset.y,
                                       self.reviewScrollView.bounds.size.width,
                                       self.reviewScrollView.contentOffset.y + self.reviewScrollView.bounds.size.height);
    nextReviewRect.origin.x += self.reviewScrollView.frame.size.width;
    [self.reviewScrollView scrollRectToVisible:nextReviewRect animated:YES];
}

@end
