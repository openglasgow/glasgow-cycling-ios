//
//  JCSearchJourneyListViewModel.h
//  JourneyCapture
//
//  Created by Michael Hayes on 20/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
#import "JCPathListViewModel.h"
#import "JCLocationManager.h"

@interface JCSearchJourneyListViewModel : JCPathListViewModel

@property (readwrite, nonatomic) CLLocationCoordinate2D destCoord;

- (RACSignal *)setDestWithAddressString:(NSString *)dest;

@end
