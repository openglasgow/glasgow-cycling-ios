//
//  JCUserJourneyListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 01/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserJourneyListViewModel.h"
#import "JCAPIManager.h"
#import "JCRouteViewModel.h"
#import "JCJourneyViewModel.h"
#import "JCPathListViewModel.h"

@implementation JCUserJourneyListViewModel
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    self.title = @"My Routes";
    self.noItemsError = @"You haven't recorded any routes";
    
    return self;
}

#pragma mark - JCJourneyListViewModel

- (NSDictionary *)searchParams
{
    return @{
             @"per_page": @1000,
             @"page_num": @1,
             @"user_only": @YES
             };
}

@end
