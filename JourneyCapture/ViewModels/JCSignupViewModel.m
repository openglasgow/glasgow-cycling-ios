//
//  JCSignupViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 25/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSignupViewModel.h"

@implementation JCSignupViewModel
@synthesize email, password, firstName, lastName, isValidDetails;

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    RACSignal *emailSignal = RACObserve(self, email);
    RACSignal *passwordSignal = RACObserve(self, password);
    RACSignal *firstNameSignal = RACObserve(self, firstName);
    RACSignal *lastNameSignal = RACObserve(self, lastName);
    
    self.isValidDetails = [RACSignal combineLatest:@[ emailSignal, passwordSignal, firstNameSignal, lastNameSignal ]
                                            reduce:^id(NSString *emailValue, NSString *passwordValue,
                                                       NSString *first, NSString *last){
                                                return @(emailValue.length > 0 && passwordValue.length > 0 &&
                                                            first.length > 0 && last.length > 0);
                                            }];
    
    return self;
}

@end
