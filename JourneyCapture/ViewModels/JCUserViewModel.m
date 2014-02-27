//
//  JCUserViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserViewModel.h"

@implementation JCUserViewModel
@synthesize firstName, lastName, favouriteRouteName, routesThisMonth, secondsThisMonth, metersThisMonth;
- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.firstName = @"John";
    self.lastName = @"Smith";
    self.favouriteRouteName = @"London Rd to Hope St";
    self.routesThisMonth = @(13);
    self.secondsThisMonth = @(51120);
    self.metersThisMonth = @(36000);
    return self;
}
@end
