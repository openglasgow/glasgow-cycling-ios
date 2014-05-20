//
//  JCStatsViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

extern NSString *kStatsDistanceKey;

@interface JCStatsViewModel : RVMViewModel
@property (strong, nonatomic) NSArray *periods;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *displayKey;
@end
