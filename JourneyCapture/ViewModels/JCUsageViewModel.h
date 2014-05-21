//
//  JCUsageViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

extern NSString *kStatsDistanceKey;

@interface JCUsageViewModel : RVMViewModel
@property (strong, nonatomic) NSArray *periods;

- (RACSignal *)loadStatsForDays:(NSInteger)numDays;
@end
