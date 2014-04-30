//
//  JCScrollView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 29/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCScrollView.h"

@implementation JCScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UIScrollView

// Allow scrolling when a button is being dragged
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

@end
