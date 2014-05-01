//
//  JCLocationManager.h
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol JCLocationManagerDelegate <NSObject>
-(void)didUpdateLocations:(NSArray *)locations;
@end

@interface JCLocationManager : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) id<JCLocationManagerDelegate> delegate;
-(void)startUpdatingCoarse;
-(void)startUpdatingNav;

- (CLLocation *)currentLocation;
+ (JCLocationManager *)sharedManager;
@end
