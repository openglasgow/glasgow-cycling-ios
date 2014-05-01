//
//  JCRoutesListViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"

@interface JCRoutesListViewModel : RVMViewModel
@property (strong, nonatomic) NSMutableArray *routes;
- (RACSignal *)loadRoutes;
//-(RACSignal *)loadUserRoutes;
//-(RACSignal *)loadNearbyRoutes;
-(void)storeRoutes:(NSArray *)routesData;
@end
