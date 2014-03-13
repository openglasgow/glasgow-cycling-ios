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
@synthesize valid, invalidView, correctBorderColor, correctBorderWidth,
                correctCornerRadius, errorBorderColor, error;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.correctBorderColor = [UIColor colorWithCGColor:self.layer.borderColor];
        self.correctCornerRadius = self.layer.cornerRadius;
        self.correctBorderWidth = self.layer.borderWidth;
        self.errorBorderColor = [UIColor redColor];
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

        [RACObserve(self, error) subscribeNext:^(id errorVal) {
            if (self.error.length == 0) {
                [self hideError];
            } else {
                [self showError];
            }
        }];
    }
    return self;
}

-(void)showError
{
    [self hideInvalid];
    [self hideError]; // Remove previous errors
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = self.errorBorderColor.CGColor;
    self.layer.cornerRadius = 5.0f;

    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.text = self.error;
    self.errorLabel.textColor = self.errorBorderColor;
    self.errorLabel.textAlignment = NSTextAlignmentRight;
    self.errorLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    [self.superview addSubview:self.errorLabel];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_top);
        make.height.equalTo(@10);
        make.top.equalTo(self.mas_top).with.offset(-10);
        make.left.equalTo(self).with.offset(self.layer.cornerRadius);
        make.right.equalTo(self).with.offset(-self.layer.cornerRadius);
    }];
}

-(void)hideError
{
    self.layer.borderColor = self.correctBorderColor.CGColor;
    self.layer.borderWidth = self.correctBorderWidth;
    self.layer.cornerRadius = self.correctCornerRadius;

    if (self.errorLabel) {
        [self.errorLabel removeFromSuperview];
        self.errorLabel = nil;
    }
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
