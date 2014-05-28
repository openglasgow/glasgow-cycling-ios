//
//  JCCycleMapViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 26/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCCycleMapViewModel : RVMViewModel
@property (strong, nonatomic) NSMutableArray *locations;
- (RACSignal *)load;
@end
