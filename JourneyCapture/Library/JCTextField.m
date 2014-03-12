//
//  JCTextField.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation JCTextField
@synthesize valid, errorView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [RACObserve(self, valid) subscribeNext:^(id validVal) {
            if (self.text.length == 0) {
                // Don't highlight empty fields are invalid
                validVal = @YES;
            }

            if ([validVal boolValue] && errorView) {
                [errorView removeFromSuperview];
                self.errorView = nil;
            } else if (![validVal boolValue] && !errorView){
                self.errorView = [[UIView alloc]
                                     initWithFrame:CGRectMake(0,0,4,self.frame.size.height)];
                errorView.backgroundColor = [UIColor redColor];

                // set the radius
                CGFloat radius = 5.0;
                // set the mask frame, and increase the height by the
                // corner radius to hide bottom corners
                CGRect maskFrame = CGRectMake(0, 0, 4+radius, self.frame.size.height);
                // create the mask layer
                CALayer *maskLayer = [CALayer layer];
                maskLayer.cornerRadius = radius;
                maskLayer.backgroundColor = [UIColor blackColor].CGColor;
                maskLayer.frame = maskFrame;

                // set the mask
                self.errorView.layer.mask = maskLayer;
                [self addSubview:errorView];
            }
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
