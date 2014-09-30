//
//  JCCycleMapViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCycleMapViewController.h"
#import "JCCycleMapView.h"
#import "JCCycleMapAnnotation.h"
#import "JCCycleMapViewModel.h"
#import "JCCycleMapLocationViewModel.h"
#import "JCCycleMapAnnotation.h"
#import "FBClusteringManager.h"

@interface JCCycleMapViewController ()

@end

@implementation JCCycleMapViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [JCCycleMapViewModel new];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cycleMapView = [[JCCycleMapView alloc] initWithViewModel:_viewModel];
    _cycleMapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_cycleMapView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_cycleMapView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_cycleMapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Glasgow Cycle Map"];
    
    _cycleMapView.mapView.delegate = self;
    [[_viewModel load] subscribeError:^(NSError *error) {
        NSLog(@"Couldn't load cycle map data");
    } completed:^{
        NSLog(@"Loaded cycle map data");
        _clusteringManager = [[FBClusteringManager alloc] initWithAnnotations:_viewModel.annotations];
        [_cycleMapView updateMap];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[JCCycleMapAnnotation class]]) {
        return nil;
    }
    
    static NSString *viewId = @"MKCycleAnnotation";
    MKAnnotationView *annotationView = (MKAnnotationView*) [_cycleMapView.mapView
                                                            dequeueReusableAnnotationViewWithIdentifier:viewId];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:viewId];
    }
    annotationView.image = ((JCCycleMapAnnotation *) annotation).viewModel.image;
    annotationView.layer.masksToBounds = YES;
    annotationView.layer.cornerRadius = 18.5f;
    return annotationView;
}

@end
