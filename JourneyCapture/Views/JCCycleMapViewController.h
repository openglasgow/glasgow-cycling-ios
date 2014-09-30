//
//  JCCycleMapViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@import MapKit;
@class JCCycleMapView, JCCycleMapViewModel, FBClusteringManager;

@interface JCCycleMapViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) JCCycleMapViewModel *viewModel;
@property (strong, nonatomic) JCCycleMapView *cycleMapView;
@property (strong, nonatomic) FBClusteringManager *clusteringManager;
@end
