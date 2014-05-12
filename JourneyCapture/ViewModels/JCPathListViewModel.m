//
// Created by Chris Sloey on 12/05/2014.
// Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCJourneyViewModel.h"
#import "JCRouteViewModel.h"
#import "JCUserJourneyListViewModel.h"
#import "JCPathListViewModel.h"


@implementation JCPathListViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (RACSignal *)loadItems
{
    return [RACSignal empty];
}

-(void)storeItems:(NSArray *)allItemData
{
    for (int i = 0; i < allItemData.count; i++) {
        NSDictionary *journeyData = allItemData[i];
        JCJourneyViewModel *journey = [[JCJourneyViewModel alloc] init];

        NSString *startName;
        if (journeyData[@"start_name"] != [NSNull null]) {
            startName = journeyData[@"start_name"];
        }

        NSString *endName;
        if (journeyData[@"end_name"] != [NSNull null]) {
            startName = journeyData[@"end_name"];
        }

        if (startName && endName) {
            [journey setName:[NSString stringWithFormat:@"%@ to %@", startName, endName]];
        } else if (startName) {
            [journey setName:[NSString stringWithFormat:@"from %@", startName]];
        } else if (endName) {
            [journey setName:[NSString stringWithFormat:@"to %@", endName]];
        } else {
            [journey setName:@"Glasgow City Route"];
        }

        [journey setNumInstances:[journeyData[@"num_routes"] intValue]];
        [journey setNumReviews:[journeyData[@"num_reviews"] intValue]];

        // Average values
        NSDictionary *averages = journeyData[@"averages"];

        double safetyRating = 0;
        if (averages[@"safety_rating"] != [NSNull null]) {
            safetyRating = [averages[@"safety_rating"] doubleValue];
        }
        [journey setSafetyRating:safetyRating];

        double difficultyRating = 0;
        if (averages[@"difficulty_rating"] != [NSNull null]) {
            difficultyRating = [averages[@"difficulty_rating"] doubleValue];
        }
        [journey setDifficultyRating:difficultyRating];

        double environmentRating = 0;
        if (averages[@"environment_rating"] != [NSNull null]) {
            environmentRating = [averages[@"environment_rating"] doubleValue];
        }
        [journey setSafetyRating:environmentRating];

        double averageRating = (safetyRating + difficultyRating + environmentRating) / 3.0f;
        [journey setSafetyRating:averageRating];

        double time = 0;
        if (averages[@"time"] != [NSNull null]) {
            time = [averages[@"time"] doubleValue];
        }
        [journey setTime:@(time)];

        double distanceKm = 0;
        if (averages[@"distance"] != [NSNull null]) {
            distanceKm = [averages[@"distance"] doubleValue];
        }
        double distanceMiles = distanceKm * 0.621371192;
        [journey setAverageMiles:@(distanceMiles)];

        [[self items] addObject:journey];
    }
}
@end