//
//  User.h
//  JourneyCapture
//
//  Created by Chris Sloey on 14/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * monthRoutes;
@property (nonatomic, retain) NSNumber * monthKm;
@property (nonatomic, retain) NSNumber * monthSeconds;
@property (nonatomic, retain) NSData * image;

@end
