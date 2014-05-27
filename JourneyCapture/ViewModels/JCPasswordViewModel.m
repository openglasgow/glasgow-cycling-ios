//
//  JCPasswordViewModel.m
//  JourneyCapture
//
//  Created by Michael Hayes on 27/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPasswordViewModel.h"
#import "User.h"

@implementation JCPasswordViewModel

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _user = [User MR_findFirst];
    [self loadEmailFromUser:_user];
  
}



-(void)loadEmailFromUser:(User *)userModel
{
    _user = userModel;
    [self setEmail:_user.email];
}
@end
