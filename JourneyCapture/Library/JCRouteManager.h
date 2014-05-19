//
//  JCRouteManager.h
//  JourneyCapture
//
//  Created by Chris Sloey on 15/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import Foundation;
@class Route;


@interface JCRouteManager : NSObject
- (void)deleteIncompleteRoutes;
- (void)uploadCompletedRoutes;
- (void)uploadRoute:(Route *)route;
+ (JCRouteManager *)sharedManager;
@end
