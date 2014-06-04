//
//  JCTextField.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"

@implementation JCTextField

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    _pasteDisabled = NO;
    if (self) {
        _correctBorderColor = [UIColor colorWithCGColor:self.layer.borderColor];
        _correctCornerRadius = self.layer.cornerRadius;
        _correctBorderWidth = self.layer.borderWidth;
        _errorBorderColor = [UIColor redColor];
        _error = NO;
        [RACObserve(self, valid) subscribeNext:^(id validVal) {
            if (self.text.length == 0) {
                // Don't highlight empty fields are invalid
                validVal = @YES;
            }

            if ([validVal boolValue] && _invalidView) {
                [self hideInvalid];
            } else if (![validVal boolValue]){
                [self showInvalid];
            }
        }];

        [RACObserve(self, error) subscribeNext:^(id error) {
            if (_error) {
                [self showError];
            } else {
                [self hideError];
            }
        }];
    }
    return self;
}

#pragma mark - JCTextField

- (void)showError
{
    [Flurry logEvent:@"Text Field Error"];

    [self hideInvalid];
    [self hideError]; // Remove previous errors
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = _errorBorderColor.CGColor;
    self.layer.cornerRadius = 5.0f;
}

- (void)hideError
{
    self.layer.borderColor = _correctBorderColor.CGColor;
    self.layer.borderWidth = _correctBorderWidth;
    self.layer.cornerRadius = _correctCornerRadius;
}

- (void)showInvalid
{
    if (_invalidView) {
        return;
    }
    // Data is invalid, show an invalid view if it doesn't exist
    _invalidView = [[UIView alloc]
                        initWithFrame:CGRectMake(0,0,4,self.frame.size.height)];
    _invalidView.backgroundColor = [UIColor redColor];

    // Round the top and bottom left corners by creating a rounded mask which
    // is too wide to mask the right-side corners
    CGFloat radius = 5.0;
    CGRect maskFrame = CGRectMake(0, 0, 4+radius, self.frame.size.height);
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = radius;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = maskFrame;
    _invalidView.layer.mask = maskLayer;

    [self addSubview:_invalidView];
}

- (void)hideInvalid
{
    if (_invalidView) {
        [_invalidView removeFromSuperview];
        _invalidView = nil;
    }
}

#pragma mark - UITextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (_pasteDisabled && action == @selector(paste:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
