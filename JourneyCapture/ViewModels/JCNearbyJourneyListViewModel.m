//
//  JCNearbyJourneyListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 13/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCNearbyJourneyListViewModel.h"
#import "JCAPIManager.h"
#import "JCLocationManager.h"

@implementation JCNearbyJourneyListViewModel
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    self.title = @"Nearby Routes";
    
    return self;
}

#pragma mark - JCJourneyListViewModel

- (NSDictionary *)searchParams
{
    CLLocationCoordinate2D userCoords = [[JCLocationManager sharedManager] currentLocation].coordinate;
    return @{
             @"per_page": @1000,
             @"page_num": @1,
             @"source_lat": @(userCoords.latitude),
             @"source_long": @(userCoords.longitude),
             };
}

@end
