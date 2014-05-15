//
//  Weather.h
//  JourneyCapture
//
//  Created by Chris Sloey on 15/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSString * iconName;
@property (nonatomic, retain) NSNumber * precipitation;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * windSpeed;
@property (nonatomic, retain) NSString * source;

@end
