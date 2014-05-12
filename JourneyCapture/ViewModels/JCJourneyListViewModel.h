//
//  JCJourneyListViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCJourneyListViewModel : RVMViewModel
@property (strong, nonatomic) NSMutableArray *journeys;
@property (strong, nonatomic) NSString *title;
- (RACSignal *)loadJourneys;
//-(RACSignal *)loadUserRoutes;
//-(RACSignal *)loadNearbyRoutes;
-(void)storeJourneys:(NSArray *)allJourneyData;
@end
