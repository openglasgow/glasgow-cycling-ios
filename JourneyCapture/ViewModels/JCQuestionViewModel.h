//
//  JCOnboardingViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 04/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCQuestionViewModel : RVMViewModel
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *question;
@property(strong, nonatomic) NSArray *answers;
@property(strong, nonatomic) NSNumber *selectedAnswerIndex;
@property(strong, nonatomic) NSString *information;
@end
