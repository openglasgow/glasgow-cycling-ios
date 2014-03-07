//
//  JCRouteCaptureViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCaptureViewModel.h"
#import "JCRoutePointViewModel.h"
#import <MapKit/MapKit.h>

@implementation JCRouteCaptureViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.points = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setCurrentSpeed:(double)currentSpeed
{
    self->_currentSpeed = currentSpeed;

    // Average speed
    double totalSpeeds = 0.0;
    if (self.points.count > 0) {
        for (int i = 0; i < self.points.count; i++) {
            JCRoutePointViewModel *point = self.points[i];
            totalSpeeds += point.speed;
        }
        self.averageSpeed = totalSpeeds / self.points.count;
    }
}

-(void)addPoint:(JCRoutePointViewModel *)point
{
    [self.points addObject:point];
    if (self.points.count > 1) {
        self.totalMetres = 0;
        for (int i = 0; i < self.points.count - 1; i++) {
            JCRoutePointViewModel *thisPoint = self.points[i];
            JCRoutePointViewModel *nextPoint = self.points[i+1];
            CLLocation *firstLoc = thisPoint.location;
            CLLocation *nextLoc = nextPoint.location;
            self.totalMetres += [nextLoc distanceFromLocation:firstLoc];
        }
    }
}

@end
