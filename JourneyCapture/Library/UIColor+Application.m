//
//  UIColor+Application.m
//  JourneyCapture
//
//  Created by Chris Sloey on 29/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "UIColor+Application.h"

@implementation UIColor (Application)

+ (UIColor *)jc_blueColor
{
    return [UIColor colorWithRed:0.0f green:161/255.0f blue:223/255.0f alpha:1.0f];
}

+ (UIColor *)jc_mediumBlueColor
{
    return [UIColor colorWithRed:0/255.0f green:171/255.0f blue:237/255.0f alpha:1.0f];
}

+ (UIColor *)jc_lightBlueColor
{
    return [UIColor colorWithRed:76/255.0f green:185/255.0f blue:226/255.0f alpha:1.0f];
}

+ (UIColor *)jc_redColor
{
    return [UIColor colorWithRed:255/255.0f green:26/255.0f blue:26/255.0f alpha:1.0f];
}

+ (UIColor *)jc_darkGrayColor
{
    return [UIColor colorWithRed:88/255.0f green:77/255.0f blue:77/255.0f alpha:1.0f];
}

+ (UIColor *)jc_greenColor
{
    return [UIColor colorWithRed:(0x7E / 255.0) green:(0xD3 / 255.0) blue:(0x21 / 255.0) alpha:1.0];
}
@end
