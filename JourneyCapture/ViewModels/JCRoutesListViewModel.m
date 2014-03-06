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
    [mock setSafetyRating:@5];
    [mock setDifficultyRating:@4];
    [mock setEnvironmentRating:@3];
    [mock setEstimatedTime:@(90*60)];
    [mock setDistanceMetres:@6235];
    [mock setRouteImage:[UIImage imageNamed:@"science-centre"]];
    [[self routes] addObject:mock];

    JCRouteViewModel *mock2 = [[JCRouteViewModel alloc] init];
    [mock2 setName:@"Hope St to Science Centre"];
    [mock2 setSafetyRating:@5];
    [mock2 setDifficultyRating:@4];
    [mock2 setEnvironmentRating:@3];
    [mock2 setEstimatedTime:@(30*60)];
    [mock2 setDistanceMetres:@6000];
    [mock2 setRouteImage:[UIImage imageNamed:@"science-centre"]];
    [[self routes] addObject:mock2];

    JCRouteViewModel *mock3 = [[JCRouteViewModel alloc] init];
    [mock3 setName:@"Blah St to Science Centre"];
    [mock3 setSafetyRating:@5];
    [mock3 setDifficultyRating:@4];
    [mock3 setEnvironmentRating:@3];
    [mock3 setEstimatedTime:@(180*60)];
    [mock3 setDistanceMetres:@6000];
    [mock3 setRouteImage:[UIImage imageNamed:@"science-centre"]];
    [[self routes] addObject:mock3];

    JCRouteViewModel *mock4 = [[JCRouteViewModel alloc] init];
    [mock4 setName:@"Hope St to Science Centre"];
    [mock4 setSafetyRating:@5];
    [mock4 setDifficultyRating:@4];
    [mock4 setEnvironmentRating:@3];
    [mock4 setEstimatedTime:@(150*60)];
    [mock4 setDistanceMetres:@6000];
    [mock4 setRouteImage:[UIImage imageNamed:@"science-centre"]];
    [[self routes] addObject:mock4];

    JCRouteViewModel *mock5 = [[JCRouteViewModel alloc] init];
    [mock5 setName:@"Hope St to Science Centre"];
    [mock5 setSafetyRating:@5];
    [mock5 setDifficultyRating:@4];
    [mock5 setEnvironmentRating:@3];
    [mock5 setEstimatedTime:@(30*60)];
    [mock5 setDistanceMetres:@6000];
    [mock5 setRouteImage:[UIImage imageNamed:@"science-centre"]];
    [[self routes] addObject:mock5];

    return self;
}

@end
