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

+ (void)deleteIncomplete
{
    NSPredicate *incompletePredicate = [NSPredicate predicateWithFormat:@"completed = %@", @NO];
    NSArray *incompleteRoutes = [Route MR_findAllWithPredicate:incompletePredicate];
    if (incompleteRoutes.count > 0) {
        for (Route *incomplete in incompleteRoutes) {
            [incomplete MR_deleteEntity];
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"Deleted incomplete routes");
        }];
    }
}

# pragma mark - CoreDataGeneratedAccessors

// Work-around for ordered one-to-many CoreData bug
- (void)addPointsObject:(RoutePoint *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.points];
    [tempSet addObject:value];
    self.points = tempSet;
}

@end
