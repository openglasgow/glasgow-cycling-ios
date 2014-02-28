//
//  JCRoutesListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRoutesListViewModel.h"
#import "JCRouteViewModel.h"

@implementation JCRoutesListViewModel
@synthesize routes, title;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.routes = [[NSMutableArray alloc] init];
    
    JCRouteViewModel *mock = [[JCRouteViewModel alloc] init];
    [mock setName:@"Hope St to Science Centre"];
    [mock setSafetyRating:@"5 Star Safety"];
    [mock setLastUsed:@"Last Used 3rd February"];
    [mock setEstimatedTime:@"30 minutes"];
    [mock setDistanceKm:@"6km"];
    [mock setRouteImage:[UIImage imageNamed:@"science-centre"]];
    [[self routes] addObject:mock];

    JCRouteViewModel *mock2 = [[JCRouteViewModel alloc] init];
    [mock2 setName:@"London Rd to Hydro"];
    [mock2 setSafetyRating:@"5 Star Safety"];
    [mock2 setLastUsed:@"Last Used 8th February"];
    [mock2 setEstimatedTime:@"45 minutes"];
    [mock2 setDistanceKm:@"8km"];
    [mock2 setRouteImage:[UIImage imageNamed:@"hydro"]];
    [[self routes] addObject:mock2];
    
    JCRouteViewModel *mock3 = [[JCRouteViewModel alloc] init];
    [mock3 setName:@"Crow Rd to Glasgow Central"];
    [mock3 setSafetyRating:@"5 Star Safety"];
    [mock3 setLastUsed:@"Last Used 5th February"];
    [mock3 setEstimatedTime:@"20 minutes"];
    [mock3 setDistanceKm:@"3km"];
    [mock3 setRouteImage:[UIImage imageNamed:@"glasgow-central"]];
    [[self routes] addObject:mock3];
    
    JCRouteViewModel *mock4 = [[JCRouteViewModel alloc] init];
    [mock4 setName:@"Argle St to Glasgow Uni"];
    [mock4 setSafetyRating:@"5 Star Safety"];
    [mock4 setLastUsed:@"Last Used 7th February"];
    [mock4 setEstimatedTime:@"14 minutes"];
    [mock4 setDistanceKm:@"2.5km"];
    [mock4 setRouteImage:[UIImage imageNamed:@"glasgow-uni"]];
    [[self routes] addObject:mock4];
    
    JCRouteViewModel *mock5 = [[JCRouteViewModel alloc] init];
    [mock5 setName:@"Union St to Velodrome"];
    [mock5 setSafetyRating:@"3 Star Safety"];
    [mock5 setLastUsed:@"Last Used 24th February"];
    [mock5 setEstimatedTime:@"18 minutes"];
    [mock5 setDistanceKm:@"3km"];
    [mock5 setRouteImage:[UIImage imageNamed:@"velodrome"]];
    [[self routes] addObject:mock5];
    
    return self;
}

@end
