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
#import <CRToast/CRToast.h>

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
    if (operation.response.statusCode == 401) {
        // Unauthorized, logout
        [[GSKeychain systemKeychain] removeAllSecrets];
        if (self.navController) {
            JCWelcomeViewController *welcomeVC = [[JCWelcomeViewController alloc] init];
            [self.navController setViewControllers:@[welcomeVC] animated:NO];
            NSDictionary *options = @{
                                      kCRToastTextKey : @"Logged out",
                                      kCRToastFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                        size:18.0],
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                      kCRToastSubtitleTextKey : @"Your user details are invalid",
                                      kCRToastSubtitleFontKey : [UIFont fontWithName:@"Helvetica Neue"
                                                                                size:12.0],
                                      kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentLeft),
                                      kCRToastBackgroundColorKey : [UIColor colorWithRed:(231/255.0)
                                                                                   green:(32./255.0)
                                                                                    blue:(73.0/255.0)
                                                                                   alpha:1.0],
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                      kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                      kCRToastTimeIntervalKey : @4,
                                      kCRToastImageKey : [UIImage imageNamed:@"lock-50"]
                                      };

            [CRToastManager showNotificationWithOptions:options
                                        completionBlock:^{
                                            NSLog(@"Logout error notification shown");
                                        }];

        }
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
