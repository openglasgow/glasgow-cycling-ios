//
//  JCWelcomeView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCWelcomeView.h"

@implementation JCWelcomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _signinButton = [UIButton new];
    _signinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_signinButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [_signinButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self addSubview:_signinButton];

    _signupButton = [UIButton new];
    _signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [_signupButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self addSubview:_signupButton];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_signinButton autoRemoveConstraintsAffectingView];
    [_signinButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-200];
    [_signinButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self];

    [_signupButton autoRemoveConstraintsAffectingView];
    [_signupButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-100];
    [_signupButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self];

    [super layoutSubviews];
}

@end
