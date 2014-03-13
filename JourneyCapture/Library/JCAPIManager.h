//
//  JCAPIManager.h
//  JourneyCapture
//
//  Created by Chris Sloey on 03/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
@class JCNavViewController;

@interface JCAPIManager : AFHTTPRequestOperationManager
@property (strong, nonatomic) JCNavViewController *navController;
+ (JCAPIManager *)manager;
- (void)operation:(AFHTTPRequestOperation *)operation error:(NSError *)error callback:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
@end
