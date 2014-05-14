//
//  JCUserViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@class User;

@interface JCUserViewModel : RVMViewModel

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSNumber *routesThisMonth;
@property (strong, nonatomic) NSNumber *secondsThisMonth;
@property (strong, nonatomic) NSNumber *kmThisMonth;
@property (strong, nonatomic) UIImage *profilePic;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSArray *menuItemImages;

-(RACSignal *)fullNameSignal;
-(RACSignal *)loadDetails;
@end
