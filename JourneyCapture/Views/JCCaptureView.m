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

- (id)initWithFrame:(CGRect)frame viewModel:(JCRouteViewModel *)captureViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    _uploading = NO;
    [RACObserve(self, uploading) subscribeNext:^(id isUploading) {
        NSLog(@"Uploading changed to %@", isUploading);
        [self showUploadIndicator:[isUploading boolValue]];
        [_captureButton setEnabled:![isUploading boolValue]];
    }];

    _viewModel = captureViewModel;
    _animator = [IFTTTAnimator new];

    // Capture button
    UIColor *buttonColor = [UIColor colorWithRed:0 green:224.0/255.0 blue:184.0/255.0 alpha:1.0];
    _captureButton = [[UIButton alloc] init];
    [_captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_captureButton setTitle:@"Start" forState:UIControlStateNormal];
    [_captureButton setBackgroundColor:buttonColor];
    _captureButton.layer.masksToBounds = YES;
    _captureButton.layer.cornerRadius = 8.0f;
    [self addSubview:_captureButton];

    [_captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-25);
        make.top.equalTo(self.mas_bottom).with.offset(-75);
        make.left.equalTo(self).with.offset(22);
        make.right.equalTo(self).with.offset(-22);
    }];

    // Map view
    _mapView = [[MKMapView alloc] init];
    _mapView.layer.masksToBounds = NO;
    _mapView.layer.shadowOffset = CGSizeMake(0, 1);
    _mapView.layer.shadowRadius = 2;
    _mapView.layer.shadowOpacity = 0.5;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    _mapView.zoomEnabled = NO;
    _mapView.scrollEnabled = NO;
    _mapView.userInteractionEnabled = NO;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_mapView];

    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        _mapBottomConstraint = make.bottom.equalTo(self.mas_bottom).with.offset(-100);
    }];

    // Stats
    _statsTable = [[UITableView alloc] init];
    [self insertSubview:_statsTable belowSubview:_mapView];
    [_statsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        _statsBottomConstraint = make.bottom.equalTo(_captureButton.mas_top).with.offset(-25);
        make.left.equalTo(self);
        make.right.equalTo(self);
        _statsTopConstraint = make.top.equalTo(_captureButton.mas_top).with.offset(-85);
    }];

    // Review elements
    int scrollHeight = 100;
    _reviewScrollView = [[UIScrollView alloc] init];
    _reviewScrollView.contentSize = CGSizeMake(self.frame.size.width * 4, _reviewScrollView.frame.size.height);
    _reviewScrollView.pagingEnabled = YES;
    _reviewScrollView.showsHorizontalScrollIndicator = NO;
    _reviewScrollView.contentSize = CGSizeMake(_reviewScrollView.contentSize.width, scrollHeight);
    [self insertSubview:_reviewScrollView belowSubview:_mapView];
    [_reviewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        _reviewTopConstraint = make.top.equalTo(@(self.frame.size.height));
        _reviewBottomConstraint = make.bottom.equalTo(@(self.frame.size.height)).with.offset(scrollHeight);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];

    double labelY = 20;
    double labelHeight = 21;
    double ratingY = _safetyReviewLabel.frame.origin.y + labelHeight + 20;
    double ratingWidth = 100;
    double ratingX = (self.frame.size.width/2) - (ratingWidth/2);
    double ratingHeight = 30;

    // Guidance
    _reviewGuidanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ratingY + ratingHeight + 10, self.frame.size.width, labelHeight)];
    [_reviewGuidanceLabel setText:@"Tap to review"];
    [_reviewGuidanceLabel setTextAlignment:NSTextAlignmentCenter];
    [_reviewScrollView addSubview:_reviewGuidanceLabel];

    // Animate review guidance label with scroll
    IFTTTFrameAnimation *frameAnimation = [IFTTTFrameAnimation new];
    frameAnimation.view = _reviewGuidanceLabel;
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
    [_animator addAnimation:frameAnimation];

    [RACObserve(_reviewScrollView, contentOffset) subscribeNext:^(NSValue *value) {
        NSInteger x = floor(_reviewScrollView.contentOffset.x);
        [_animator animate:x];
    }];

    // Safety rating
    _safetyReviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, self.frame.size.width, labelHeight)];
    [_safetyReviewLabel setText:@"Safety Rating"];
    [_safetyReviewLabel setTextAlignment:NSTextAlignmentCenter];
    [_reviewScrollView addSubview:_safetyReviewLabel];

    _safetyRating = [[EDStarRating alloc] initWithFrame:CGRectMake(ratingX, ratingY, ratingWidth, ratingHeight)];
    [_safetyRating setEditable:YES];
    [_safetyRating setDisplayMode:EDStarRatingDisplayFull];
    _safetyRating.starImage = [UIImage imageNamed:@"star-template"];
    _safetyRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [_safetyRating setBackgroundColor:[UIColor clearColor]];
    _safetyRating.horizontalMargin = 5;
    [_safetyRating setDelegate:self];
    RACChannelTo(_safetyRating, rating) = RACChannelTo(_viewModel, safetyRating);
    [_reviewScrollView addSubview:_safetyRating];

    // Environment rating
    _environmentReviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, labelY, self.frame.size.width, labelHeight)];
    [_environmentReviewLabel setText:@"Environment Rating"];
    [_environmentReviewLabel setTextAlignment:NSTextAlignmentCenter];
    [_reviewScrollView addSubview:_environmentReviewLabel];

    _environmentRating = [[EDStarRating alloc] initWithFrame:CGRectMake(ratingX + self.frame.size.width, ratingY, ratingWidth, ratingHeight)];
    [_environmentRating setEditable:YES];
    [_environmentRating setDisplayMode:EDStarRatingDisplayFull];
    _environmentRating.starImage = [UIImage imageNamed:@"star-template"];
    _environmentRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [_environmentRating setBackgroundColor:[UIColor clearColor]];
    _environmentRating.horizontalMargin = 5;
    [_environmentRating setDelegate:self];
    RACChannelTo(_environmentRating, rating) = RACChannelTo(_viewModel, environmentRating);
    [_reviewScrollView addSubview:_environmentRating];

    // Difficulty rating
    _difficultyReviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*2, labelY, self.frame.size.width, labelHeight)];
    [_difficultyReviewLabel setText:@"Difficulty Rating"];
    [_difficultyReviewLabel setTextAlignment:NSTextAlignmentCenter];
    [_reviewScrollView addSubview:_difficultyReviewLabel];

    _difficultyRating = [[EDStarRating alloc] initWithFrame:CGRectMake(ratingX + (self.frame.size.width * 2), ratingY, ratingWidth, ratingHeight)];
    [_difficultyRating setEditable:YES];
    [_difficultyRating setDisplayMode:EDStarRatingDisplayFull];
    _difficultyRating.starImage = [UIImage imageNamed:@"star-template"];
    _difficultyRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [_difficultyRating setBackgroundColor:[UIColor clearColor]];
    _difficultyRating.horizontalMargin = 5;
    [_difficultyRating setDelegate:self];
    RACChannelTo(_difficultyRating, rating) = RACChannelTo(_viewModel, difficultyRating);
    [_reviewScrollView addSubview:_difficultyRating];

    // Review complete
    _reviewCompleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*3, 40,
                                                                         self.frame.size.width, labelHeight)];
    [_reviewCompleteLabel setText:@"Review completed! Please submit"];
    [_reviewCompleteLabel setTextAlignment:NSTextAlignmentCenter];
    [_reviewScrollView addSubview:_reviewCompleteLabel];

    return self;
}

- (void)transitionToActive
{
    // Move map and button
    [_mapBottomConstraint uninstall];
    [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        _mapBottomConstraint = make.bottom.equalTo(_captureButton.mas_top).with.offset(-self.frame.size.height/3.7);
    }];

    [_statsTopConstraint uninstall];
    [_statsTable mas_updateConstraints:^(MASConstraintMaker *make) {
        _statsTopConstraint = make.top.equalTo(_mapView.mas_bottom);
    }];

    UIColor *stopColor = [UIColor colorWithRed:243.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_mapView layoutIfNeeded];
                         [_statsTable layoutIfNeeded];
                         [_captureButton setTitle:@"Stop" forState:UIControlStateNormal];
                         [_captureButton setBackgroundColor:stopColor];
                         [_statsTable reloadData];
                     }
                     completion:^(BOOL finished){
                         // Adjusting map can stop tracking
                         [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
                     }];
}

- (void)transitionToComplete
{
    // Hide user location
    [_mapView setShowsUserLocation:NO];

    // Calculate map area in which route is held
    MKMapRect zoomRect = MKMapRectNull;
    for (JCRoutePointViewModel *point in _viewModel.points)
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
    [_mapBottomConstraint uninstall];
    [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        _mapBottomConstraint = make.bottom.equalTo(_captureButton.mas_top).with.offset(-self.frame.size.height/2.5);
    }];

    double statsHeight = _statsTable.frame.size.height;
    double tableOffset = statsHeight - (2 * [_statsTable rowHeight]);
    [_statsTopConstraint uninstall];
    [_statsBottomConstraint uninstall];
    [_statsTable mas_updateConstraints:^(MASConstraintMaker *make) {
        _statsTopConstraint = make.top.equalTo(_mapView.mas_bottom).with.offset(-(statsHeight/3));
        _statsBottomConstraint = make.bottom.equalTo(_mapView.mas_bottom).with.offset(2*(statsHeight/3));
    }];

    double statsBottom = 200 - tableOffset + _statsTable.frame.size.height;
    _reviewScrollView.frame = CGRectMake(0, statsBottom + 25,
                                             self.frame.size.width, _reviewScrollView.frame.size.height);

    [_reviewTopConstraint uninstall];
    [_reviewBottomConstraint uninstall];
    [_reviewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        _reviewTopConstraint = make.top.equalTo(_statsTable.mas_bottom).with.offset(10);
        _reviewBottomConstraint = make.bottom.equalTo(_statsTable.mas_bottom).with.offset(110);
    }];

    // Slide stats and review view up
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Shrink map, hide current speed
                         [_mapView layoutIfNeeded];
                         [_statsTable layoutIfNeeded];

                         // Show review scrollview
                         [_reviewScrollView layoutIfNeeded];

                         // Submit button
                         [_captureButton setTitle:@"Submit" forState:UIControlStateNormal];
                         [_captureButton setBackgroundColor:self.tintColor];
                     }
                     completion:^(BOOL finished){
                         // Show entire route
                         [_mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
                         [_mapView setVisibleMapRect:zoomRect animated:YES];
                     }];
}

-(void)showUploadIndicator:(BOOL)show
{
    if (!show) {
        if (_uploadView) {
            [_uploadView removeFromSuperview];
            _uploadView = nil;

            [_uploadIndicatorView removeFromSuperview];
            _uploadIndicatorView = nil;
        }
        return;
    }

    if (_uploadView && _uploadIndicatorView) {
        return;
    }

    _uploadView = [UIView new];
    [_uploadView setBackgroundColor:[UIColor whiteColor]];

    _uploadIndicatorView = [UIActivityIndicatorView new];
    _uploadIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_uploadIndicatorView startAnimating];

    [self insertSubview:_uploadView aboveSubview:_reviewScrollView];
    [_uploadView addSubview:_uploadIndicatorView];

    [_uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statsTable.mas_bottom);
        make.bottom.equalTo(_captureButton.mas_top).with.offset(-25);
        make.right.equalTo(self);
        make.left.equalTo(self);
    }];

    [_uploadIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_uploadView);
        make.bottom.equalTo(_captureButton.mas_top).with.offset(-50);
    }];
        
}

- (void)updateRouteLine
{
    NSUInteger numPoints = [_viewModel.points count];

    if (numPoints < 2) {
        return;
    }

    JCRoutePointViewModel *point = _viewModel.points[numPoints-1];
    CLLocationCoordinate2D coord = point.location.coordinate;

    JCRoutePointViewModel *previousPoint = _viewModel.points[numPoints-2];
    CLLocationCoordinate2D previousCoord = previousPoint.location.coordinate;

    MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
    pointsArray[0]= MKMapPointForCoordinate(previousCoord);
    pointsArray[1]= MKMapPointForCoordinate(coord);

    _routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
    free(pointsArray);

    [[self mapView] addOverlay:_routeLine];
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
    MKCoordinateSpan zoomSpan = _mapView.region.span;
    if (zoomSpan.latitudeDelta > 1 || zoomSpan.longitudeDelta > 1) {
        // 1 might be a bit large, but delta is typically initially ~50-55
        CLLocationCoordinate2D loc = [userLocation coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
        [_mapView setRegion:region animated:YES];
    }
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    // Show next review
    CGRect nextReviewRect = CGRectMake(_reviewScrollView.contentOffset.x,
                                       _reviewScrollView.contentOffset.y,
                                       _reviewScrollView.bounds.size.width,
                                       _reviewScrollView.contentOffset.y + _reviewScrollView.bounds.size.height);
    nextReviewRect.origin.x += _reviewScrollView.frame.size.width;
    [_reviewScrollView scrollRectToVisible:nextReviewRect animated:YES];
}

@end
