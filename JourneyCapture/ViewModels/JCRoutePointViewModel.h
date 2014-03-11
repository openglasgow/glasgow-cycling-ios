//
//  JCRoutePointViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
#import <MapKit/MapKit.h>

@interface JCRoutePointViewModel : RVMViewModel
@property (strong, atomic) CLLocation *location;
@end
