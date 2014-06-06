//
//  CLLocation+Bearing.h
//  JourneyCapture
//
//  Created by Chris Sloey on 06/06/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Bearing)
- (double)bearingToLocation:(CLLocation *)destinationLocation;
@end
