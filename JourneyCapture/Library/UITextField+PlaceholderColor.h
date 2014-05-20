//
//  UITextField+PlaceholderColor.h
//  JourneyCapture
//
//  Created by Michael Hayes on 20/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PlaceholderColor)
- (void)swizzled_drawPlaceholderInRect:(CGRect)rect;
+ (void)swizzleDrawPlaceholder;
@end
