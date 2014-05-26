//
//  JCCycleMapLocationViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
@import MapKit;

@interface JCCycleMapLocationViewModel : RVMViewModel
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
@end
