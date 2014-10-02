//
//  JCCycleMapView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import MapKit;
@class JCCycleMapViewModel, OCMapView;

@interface JCCycleMapView : UIView
@property (strong, nonatomic) JCCycleMapViewModel *viewModel;
@property (strong, nonatomic) OCMapView *mapView;
- (id)initWithViewModel:(JCCycleMapViewModel *)mapViewModel;
- (void)updateMap;
@end
