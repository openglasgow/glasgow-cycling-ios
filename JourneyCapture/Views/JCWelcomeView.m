//
//  JCWelcomeView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 26/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCWelcomeView.h"

@implementation JCWelcomeView
@synthesize signupButton, signinButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    // Buttons
    self.signinButton = [[UIButton alloc] init];
    [self.signinButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [self.signinButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self addSubview:self.signinButton];
    
    self.signupButton = [[UIButton alloc] init];
    [self.signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self addSubview:self.signupButton];
    
    // Positioning
    [self.signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self).with.offset(-200);
    }];
    
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self).with.offset(-100);
    }];
    
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
