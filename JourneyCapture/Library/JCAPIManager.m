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
// TODO DRY up these with an authentication manager or similar ?

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
        return [super GET:URLString parameters:authParams success:success failure:failure];
    } else {
        [[GSKeychain systemKeychain] removeAllSecrets];
        return [super GET:URLString parameters:parameters success:success failure:failure];
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
        return [super POST:URLString parameters:authParams success:success failure:failure];
    } else {
        return [super POST:URLString parameters:parameters success:success failure:failure];
    }
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
}@end
