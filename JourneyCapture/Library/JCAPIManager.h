//
//  JCAPIManager.h
//  JourneyCapture
//
//  Created by Chris Sloey on 03/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface JCAPIManager : AFHTTPRequestOperationManager
+ (JCAPIManager *)manager;
@end
