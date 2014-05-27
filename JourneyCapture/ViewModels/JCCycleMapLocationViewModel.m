//
//  JCCycleMapLocationViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCCycleMapLocationViewModel.h"

@implementation JCCycleMapLocationViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake(55.4, -4.29);
        _name = @"Cycle Rack";
        _image = [UIImage imageNamed:@"map-pin-lock"];
    }
    return self;
}
@end
