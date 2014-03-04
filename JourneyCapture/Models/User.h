//
//  User.h
//  JourneyCapture
//
//  Created by Chris Sloey on 03/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * monthSeconds;
@property (nonatomic, retain) NSString * monthFavouriteRoute;
@property (nonatomic, retain) NSNumber * monthMeters;
@property (nonatomic, retain) NSString * lastName;

@end
