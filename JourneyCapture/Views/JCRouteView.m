//
//  JCRouteView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteView.h"
#import "JCRouteViewModel.h"

@implementation JCRouteView

- (id)initWithViewModel:(JCRouteViewModel *)routeViewModel
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _viewModel = routeViewModel;
    
    
    return self;
}

# pragma mark - UIView

- (void)layoutSubviews
{
    
    
    [super layoutSubviews];
}

@end
