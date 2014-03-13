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
@synthesize valid, invalidView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [RACObserve(self, valid) subscribeNext:^(id validVal) {
            if (self.text.length == 0) {
                // Don't highlight empty fields are invalid
                validVal = @YES;
            }

            if ([validVal boolValue] && invalidView) {
                [self hideInvalid];
            } else if (![validVal boolValue]){
                [self showInvalid];
            }
        }];
    }
    return self;
}

-(void)showError
{

}

-(void)hideError
{

}

-(void)showInvalid
{
    if (self.invalidView) {
        return;
    }
    // Data is invalid, show an invalid view if it doesn't exist
    self.invalidView = [[UIView alloc]
                        initWithFrame:CGRectMake(0,0,4,self.frame.size.height)];
    self.invalidView.backgroundColor = [UIColor redColor];

    // Round the top and bottom left corners by creating a rounded mask which
    // is too wide to mask the right-side corners
    CGFloat radius = 5.0;
    CGRect maskFrame = CGRectMake(0, 0, 4+radius, self.frame.size.height);
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = radius;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = maskFrame;
    self.invalidView.layer.mask = maskLayer;

    [self addSubview:self.invalidView];
}

-(void)hideInvalid
{
    if (self.invalidView) {
        [invalidView removeFromSuperview];
        self.invalidView = nil;
    }
}

@end
