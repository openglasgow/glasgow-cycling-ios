//
//  JCGraphFooterView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 21/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCGraphFooterView.h"

@implementation JCGraphFooterView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _axisImageView = [[UIImageView alloc] initWithImage:image];
        _axisImageView.frame = CGRectMake(15, 17, frame.size.width - 30, frame.size.height - 23);
        [self addSubview:_axisImageView];
    }
    return self;
}

@end
