//
//  JCLoadingView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 01/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCLoadingView.h"

@interface JCLoadingView ()
- (void)spinImage:(UIImageView *)image withOptions:(UIViewAnimationOptions)options;
@end

@implementation JCLoadingView

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *frameImage = [UIImage imageNamed:@"bike_rider"];
        UIImage *wheelImage = [UIImage imageNamed:@"wheel"];
        
        _bikeFrame = [[UIImageView alloc] initWithImage:frameImage];
        _bikeFrame.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_bikeFrame];
        
        _backWheel = [[UIImageView alloc] initWithImage:wheelImage];
        _backWheel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backWheel];
        
        _frontWheel = [[UIImageView alloc] initWithImage:wheelImage];
        _frontWheel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_frontWheel];
        
        [RACObserve(self, loading) subscribeNext:^(id x) {
            if (_loading) {
                [self spinImage:_backWheel withOptions:UIViewAnimationOptionCurveEaseIn];
                [self spinImage:_frontWheel withOptions:UIViewAnimationOptionCurveEaseIn];
            }
        }];
    }
    return self;
}

- (void)spinImage:(UIImageView *)image withOptions:(UIViewAnimationOptions)options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.1f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         image.transform = CGAffineTransformRotate(image.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (_loading) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinImage:image withOptions:UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinImage:image withOptions:UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_bikeFrame autoRemoveConstraintsAffectingView];
    [_bikeFrame autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 26, 15, 28)];
    
    [_backWheel autoRemoveConstraintsAffectingView];
    [_backWheel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bikeFrame withOffset:42];
    [_backWheel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_bikeFrame withOffset:-29];
    [_backWheel autoSetDimensionsToSize:CGSizeMake(41, 41)];
    
    [_frontWheel autoRemoveConstraintsAffectingView];
    [_frontWheel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_backWheel];
    [_frontWheel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bikeFrame withOffset:30];
    [_frontWheel autoSetDimensionsToSize:CGSizeMake(41, 41)];

    [super layoutSubviews];
}

@end
