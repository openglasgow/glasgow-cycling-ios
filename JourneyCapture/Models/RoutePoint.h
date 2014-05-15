//
//  RoutePoint.h
//  JourneyCapture
//
//  Created by Chris Sloey on 14/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoutePoint : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * kph;
@property (nonatomic, retain) NSNumber * horizontalAccuracy;
@property (nonatomic, retain) NSNumber * verticalAccuracy;
@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSString * streetName;
@property (nonatomic, retain) NSNumber * course;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSManagedObject *route;

@end
