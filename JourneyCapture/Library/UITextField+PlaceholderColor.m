//
//  UITextField+PlaceholderColor.m
//  JourneyCapture
//
//  Created by Michael Hayes on 20/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "UITextField+PlaceholderColor.h"
#import <objc/runtime.h>

@implementation UITextField (PlaceholderColor)

- (void)swizzled_drawPlaceholderInRect:(CGRect)rect
{
    CGRect placeholderRect = [self textRectForBounds:rect];
    placeholderRect.origin = (CGPoint) { 0, 4 };
    
    [self.placeholder drawInRect:placeholderRect
                  withAttributes:@{
                                   NSFontAttributeName: self.font,
                                   NSForegroundColorAttributeName: [UIColor whiteColor]
                                   }];
}

+ (void)swizzleDrawPlaceholder
{
    Method original = class_getInstanceMethod([UITextField class],
                                              @selector(drawPlaceholderInRect:));
    Method swizzled = class_getInstanceMethod([UITextField class],
                                              @selector(swizzled_drawPlaceholderInRect:));
    method_exchangeImplementations(original, swizzled);
}

@end
