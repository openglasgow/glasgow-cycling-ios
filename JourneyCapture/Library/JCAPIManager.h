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
- (AFHTTPRequestOperation *)refreshTokenOperationWithSuccessOperation:(AFHTTPRequestOperation *)successOperation
                                                              success:(void (^)(AFHTTPRequestOperation *, id))success
                                                              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
- (void)operation:(AFHTTPRequestOperation *)operation error:(NSError *)error
          success:(void (^)(AFHTTPRequestOperation *, id))success
          failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
@end
