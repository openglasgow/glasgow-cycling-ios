//
//  JCAPIManager.m
//  JourneyCapture
//
//  Created by Chris Sloey on 03/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCAPIManager.h"
#import "JCUserManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <GSKeychain/GSKeychain.h>
#import "JCSigninViewController.h"
#import "JCNavViewController.h"
#import "JCNotificationManager.h"
#import "Flurry.h"

@implementation JCAPIManager

#pragma mark - Initialization

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(!self) {
        return nil;
    }

    self.shouldUseCredentialStorage = NO;
    self.requestSerializer = [AFJSONRequestSerializer serializer];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    return self;
}

#pragma mark - Authenticated Requests

- (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *accessToken = [[GSKeychain systemKeychain] secretForKey:@"access_token"];
    NSString *bearerHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [self.requestSerializer setValue:bearerHeader forHTTPHeaderField:@"Authorization"];
    return [super GET:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self operation:operation error:error success:success failure:failure];
    }];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *accessToken = [[GSKeychain systemKeychain] secretForKey:@"access_token"];
    NSString *bearerHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [self.requestSerializer setValue:bearerHeader forHTTPHeaderField:@"Authorization"];
    return [super POST:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self operation:operation error:error success:success failure:failure];
    }];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *accessToken = [[GSKeychain systemKeychain] secretForKey:@"access_token"];
    NSString *bearerHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [self.requestSerializer setValue:bearerHeader forHTTPHeaderField:@"Authorization"];
    return [super PUT:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self operation:operation error:error success:success failure:failure];
    }];
}

- (void)operation:(AFHTTPRequestOperation *)operation error:(NSError *)error
          success:(void (^)(AFHTTPRequestOperation *, id))success
          failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    BOOL isSignin = [operation.request.URL.lastPathComponent
                                    rangeOfString:@"token"].location != NSNotFound;
    NSLog(@"Param string: %@", operation.request.URL.parameterString);
    BOOL isRefresh = operation.request.URL.parameterString && [operation.request.URL.parameterString
                                                               rangeOfString:@"refresh_token"].location != NSNotFound;
    BOOL isChangePassword = [operation.request.URL.lastPathComponent
                                    rangeOfString:@"reset_password.json"].location != NSNotFound;
    if (operation.response.statusCode == 401 && !isSignin && !isChangePassword) {
        if (isRefresh) {
            // Unauthorized, logout
            [Flurry logEvent:@"Unauthorized Request"];
            [[JCNotificationManager manager] displayErrorWithTitle:@"Logged out"
                                                          subtitle:@"Your user details are invalid"
                                                              icon:[UIImage imageNamed:@"logged-out-icon"]];
            [[JCUserManager sharedManager] logout];
        } else {
            [self refreshTokenOperationWithSuccessOperation:operation success:success failure:failure];
            return;
        }
    } else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1004) {
        // Couldn't connect to server
        [Flurry logEvent:@"Connection Error"];
        [[JCNotificationManager manager] displayErrorWithTitle:@"Connection Error"
                                                      subtitle:@"There was a problem connecting to the server"
                                                          icon:[UIImage imageNamed:@"connection-issue-icon"]];
    }

    failure(operation, error);
}

- (AFHTTPRequestOperation *)refreshTokenOperationWithSuccessOperation:(AFHTTPRequestOperation *)successOperation
                                                              success:(void (^)(AFHTTPRequestOperation *, id))success
                                                              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    BOOL isSignin = [successOperation.request.URL.lastPathComponent
                     rangeOfString:@"token"].location != NSNotFound;
    if (isSignin) {
        return successOperation;
    }
    
    NSString *refreshToken = [[GSKeychain systemKeychain] secretForKey:@"refresh_token"];
    if (!refreshToken) {
        [[JCNotificationManager manager] displayErrorWithTitle:@"Logged Out"
                                                      subtitle:@"Confirm your details to log in again"
                                                          icon:[UIImage imageNamed:@"logged-out-icon"]];
        [[JCUserManager sharedManager] logout];
    }
    
    NSDictionary *refreshParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   CLIENT_ID, @"client_id",
                                   CLIENT_SECRET, @"client_secret",
                                   @"refresh_token", @"grant_type",
                                   refreshToken, @"refresh_token",
                                   nil];
    return [super POST:@"/oauth/token" parameters:refreshParams
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"Token details successfully retrieved");
                     NSLog(@"Refresh success");
                     NSLog(@"%@", responseObject);
                     NSString *accessToken = [responseObject objectForKey:@"access_token"];
                     NSString *refreshToken = [responseObject objectForKey:@"refresh_token"];
                     if (accessToken) {
                         [[GSKeychain systemKeychain] setSecret:accessToken forKey:@"access_token"];
                         NSString *bearerHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
                         [self.requestSerializer setValue:bearerHeader forHTTPHeaderField:@"Authorization"];
                     }
                     
                     if (refreshToken) {
                         [[GSKeychain systemKeychain] setSecret:refreshToken forKey:@"refresh_token"];
                     }
                     
                     NSNumber *expiresIn = [responseObject objectForKey:@"expires_in"];
                     NSDate *expiresAt = [NSDate dateWithTimeIntervalSinceNow:expiresIn.integerValue];
                     [[NSUserDefaults standardUserDefaults] setObject:expiresAt forKey:@"expires_at"];
                     
                     if (!accessToken && !refreshToken) {
                         [[JCUserManager sharedManager] logout];
                     } else {
                         NSMutableURLRequest *mutableRequest = successOperation.request.mutableCopy;
                         NSMutableDictionary *headers = mutableRequest.allHTTPHeaderFields.mutableCopy;
                         [headers setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forKey:@"Authorization"];
                         mutableRequest.allHTTPHeaderFields = headers;

                         AFHTTPRequestOperation *retryOperation = [self HTTPRequestOperationWithRequest:mutableRequest
                                                                                                success:success
                                                                                                failure:failure];
                         [retryOperation start];
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [[JCNotificationManager manager] displayErrorWithTitle:@"Logged Out"
                                                                   subtitle:@"Confirm your details to log in again"
                                                                       icon:[UIImage imageNamed:@"logged-out-icon"]];
                     [[JCUserManager sharedManager] logout];
                 }];
}

#pragma mark - Singleton Methods

+ (JCAPIManager *)manager
{
    static dispatch_once_t pred;
    static JCAPIManager *_sharedManager = nil;

    dispatch_once(&pred, ^{
        _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_URI]];
    });
    return _sharedManager;
}
@end
