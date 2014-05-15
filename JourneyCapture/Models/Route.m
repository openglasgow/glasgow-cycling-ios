//
//  Route.m
//  JourneyCapture
//
//  Created by Chris Sloey on 15/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "Route.h"
#import "RoutePoint.h"


@implementation Route

@dynamic completed;
@dynamic points;

// Work-around for ordered one-to-many CoreData bug
- (void)addPointsObject:(RoutePoint *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.points];
    [tempSet addObject:value];
    self.points = tempSet;
}

@end
