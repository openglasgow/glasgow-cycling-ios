//
//  JCRouteViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteViewController.h"
#import "JCRouteViewModel.h"
#import "JCRoutePointViewModel.h"

@interface JCRouteViewController ()

@end

@implementation JCRouteViewController
@synthesize viewModel, routeImageView, mapView;

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.viewModel = routeViewModel;
    return self;
}

# pragma mark - UIViewController

- (void)loadView
{
    self.view = [UIView new];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Load route points
    [[self.viewModel loadPoints] subscribeError:^(NSError *error) {
        NSLog(@"Error loading route points");
    } completed:^{
        NSLog(@"Loaded route points");

        // Draw points
        NSUInteger numPoints = [self.viewModel.points count];

        if (numPoints < 2) {
            return;
        }

        MKMapPoint *pointsArray = malloc(sizeof(CLLocationCoordinate2D)*numPoints);
        for (int i = 0; i < numPoints; i++) {
            JCRoutePointViewModel *point = self.viewModel.points[i];
            pointsArray[i] = MKMapPointForCoordinate(point.location.coordinate);
        }

        MKPolyline *routeLine = [MKPolyline polylineWithPoints:pointsArray count:numPoints];
        free(pointsArray);
        
        [[self mapView] addOverlay:routeLine];

        // Zoom to points
        MKMapRect zoomRect = MKMapRectNull;
        for (JCRoutePointViewModel *point in self.viewModel.points)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(point.location.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 350.0, 350.0);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
    }];

    [self setTitle:self.viewModel.name];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = self.view.tintColor;
    renderer.lineWidth = 2.5;
    return  renderer;
}

@end
