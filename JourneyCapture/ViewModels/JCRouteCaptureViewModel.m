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

-(void)addPoint:(JCRoutePointViewModel *)point
{
    [self.points addObject:point];

    // Calculate total distance
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

    // Calculate current speed
    if (self.points.count > 0) {
        JCRoutePointViewModel *lastPoint = self.points.lastObject;
        self.currentSpeed = lastPoint.location.speed;
    } else {
        self.currentSpeed = 0;
    }

    // Calculate average speed
    double totalSpeeds = 0.0;
    if (self.points.count > 0) {
        for (int i = 0; i < self.points.count; i++) {
            JCRoutePointViewModel *point = self.points[i];
            totalSpeeds += point.location.speed;
        }
        self.averageSpeed = totalSpeeds / self.points.count;
    }
}

@end
