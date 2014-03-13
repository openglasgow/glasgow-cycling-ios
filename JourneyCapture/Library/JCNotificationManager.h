//
//  JCNotificationManager.h
//  JourneyCapture
//
//  Created by Chris Sloey on 13/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCNotificationManager : NSObject
- (void)displayInfoWithTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon;
- (void)displayErrorWithTitle:(NSString *)title subtitle:(NSString *)subtitle icon:(UIImage *)icon;
+ (JCNotificationManager *)manager;
@end
