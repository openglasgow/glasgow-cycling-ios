//
//  JCNotificationManager.m
//  JourneyCapture
//
//  Created by Chris Sloey on 13/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCNotificationManager.h"
#import <CRToast/CRToast.h>

@implementation JCNotificationManager
@synthesize notificationShown;

-(void)displayErrorWithTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon
{
    if (self.notificationShown) {
        return;
    }
    self.notificationShown = YES;
    NSDictionary *options = @{
                              kCRToastTextKey : title,
                              kCRToastFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                size:18.0],
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastSubtitleTextKey : subtitle,
                              kCRToastSubtitleFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                        size:12.0],
                              kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastBackgroundColorKey : [UIColor colorWithRed:(231/255.0)
                                                                           green:(32./255.0)
                                                                            blue:(73.0/255.0)
                                                                           alpha:1.0],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastTimeIntervalKey : @4,
                              kCRToastImageKey : icon
                              };

    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Logout error notification shown");
                                    self.notificationShown = NO;
                                }];
}

-(void)displayInfoWithTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon
{
    if (self.notificationShown) {
        return;
    }
    self.notificationShown = YES;
    NSDictionary *options = @{
                              kCRToastTextKey : title,
                              kCRToastFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                size:18.0],
                              kCRToastTextColorKey : [UIColor whiteColor],
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastSubtitleTextKey : subtitle,
                              kCRToastSubtitleFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                        size:12.0],
                              kCRToastSubtitleTextColorKey : [UIColor whiteColor],
                              kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastBackgroundColorKey : [UIColor colorWithRed:69/255.0 green:87/255.0 blue:199/255.0 alpha:1.0],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastTimeIntervalKey : @2.5,
                              kCRToastImageKey : icon
                              };

    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"No routes error notification shown");
                                    self.notificationShown = NO;
                                }];
}

+ (JCNotificationManager *)manager
{
    static dispatch_once_t pred;
    static JCNotificationManager *_manager = nil;

    dispatch_once(&pred, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
@end
