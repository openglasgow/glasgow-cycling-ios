//
//  Route.h
//  JourneyCapture
//
//  Created by Chris Sloey on 14/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RoutePoint;

@interface Route : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSSet *points;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addPointsObject:(RoutePoint *)value;
- (void)removePointsObject:(RoutePoint *)value;
- (void)addPoints:(NSSet *)values;
- (void)removePoints:(NSSet *)values;

@end
