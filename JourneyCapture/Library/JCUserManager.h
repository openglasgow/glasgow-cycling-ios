//
//  JCUserManager.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCUserManager : NSObject
@property (strong, nonatomic) UINavigationController *navVC;
- (void)logout;
- (void)refreshToken;
+ (instancetype)sharedManager;
@end
