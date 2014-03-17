//
//  JCAPIManager.m
//  JourneyCapture
//
//  Created by Chris Sloey on 03/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCAPIManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <GSKeychain/GSKeychain.h>
#import "JCWelcomeViewController.h"
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

    self.requestSerializer = [AFJSONRequestSerializer serializer];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    return self;
}

#pragma mark - Authenticated Requests
- (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *userToken = [[GSKeychain systemKeychain] secretForKey:@"user_token"];
    NSString *userEmail = [[GSKeychain systemKeychain] secretForKey:@"user_email"];
    if (userToken && userEmail) {
        NSMutableDictionary *authParams;
        if (parameters) {
            authParams = [parameters mutableCopy];
        } else {
            authParams = [[NSMutableDictionary alloc] init];
        }
        authParams[@"user_token"] = userToken;
        authParams[@"user_email"] = userEmail;
        return [super GET:URLString parameters:authParams success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self operation:operation error:error callback:failure];
        }];
    } else {
        [[GSKeychain systemKeychain] removeAllSecrets];
        return [super GET:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self operation:operation error:error callback:failure];
        }];
    }
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *userToken = [[GSKeychain systemKeychain] secretForKey:@"user_token"];
    NSString *userEmail = [[GSKeychain systemKeychain] secretForKey:@"user_email"];
    if (userToken && userEmail) {
        NSMutableDictionary *authParams = [parameters mutableCopy];
        authParams[@"user_token"] = userToken;
        authParams[@"user_email"] = userEmail;
        return [super POST:URLString parameters:authParams success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self operation:operation error:error callback:failure];
        }];
    } else {
        return [super POST:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self operation:operation error:error callback:failure];
        }];
    }
}

-(void)operation:(AFHTTPRequestOperation *)operation error:(NSError *)error callback:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    BOOL isSignin = [operation.request.URL.lastPathComponent rangeOfString:@"signin.json"].location != NSNotFound;
    if (operation.response.statusCode == 401 && !isSignin) {
        // Unauthorized, logout
        [Flurry logEvent:@"Unauthorized Request"];
        [[GSKeychain systemKeychain] removeAllSecrets];
        if (self.navController) {
            JCWelcomeViewController *welcomeVC = [[JCWelcomeViewController alloc] init];
            [self.navController setViewControllers:@[welcomeVC] animated:NO];
            [[JCNotificationManager manager] displayErrorWithTitle:@"Logged out"
                                                          subtitle:@"Your user details are invalid"
                                                              icon:[UIImage imageNamed:@"confused-icon"]];

        }
    } else if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -1004) {
        // Couldn't connect to server
        [Flurry logEvent:@"Connection Error"];
        [[JCNotificationManager manager] displayErrorWithTitle:@"Connection Error"
                                                      subtitle:@"There was a problem connecting to the server"
                                                          icon:[UIImage imageNamed:@"connection-icon"]];
    }

    failure(operation, error);
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
