//
//  JCUserViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserViewModel.h"
#import "JCAPIManager.h"
#import <GSKeychain/GSKeychain.h>
#import "User.h"

@implementation JCUserViewModel
- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _menuItems = @[@"My Routes", @"Nearby Routes", @"Glasgow Cycle Map"];
    _menuItemImages = @[
                        [UIImage imageNamed:@"my-routes-icon"],
                        [UIImage imageNamed:@"nearby-routes-icon"],
                        [UIImage imageNamed:@"cycling-map-icon"]
                        ];

    if (!_user) {
        if ([User MR_countOfEntities] == 0) {
            _user = [User MR_createEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                NSLog(@"Saved new user");
            }];
        } else {
            _user = [User MR_findFirst];
            [self loadFromUser:_user];
        }
    }

    return self;
}

-(void)loadFromUser:(User *)userModel
{
    _user = userModel;
    [self setUsername:_user.username];
    [self setGender:_user.gender];
    [self setEmail:_user.email];
    [self setSecondsThisMonth:_user.monthSeconds];
    [self setKmThisMonth:_user.monthKm];
    [self setRoutesThisMonth:_user.monthRoutes];
    NSData *picData = _user.image;
    if (picData) {
        [self setProfilePic:[UIImage imageWithData:picData]];
    } else {
        [self setProfilePic:[UIImage imageNamed:@"profile-pic"]];
    }
}

-(RACSignal *)loadDetails
{
    NSLog(@"Loading user");
    JCAPIManager *manager = [JCAPIManager manager];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/details.json"
           parameters:nil
              success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                  // Loaded user details
                  NSLog(@"User load success");
                  NSLog(@"%@", responseObject);
                  
                  // Update model
                  _user.username = responseObject[@"username"];
                  _user.gender = responseObject[@"gender"];
                  _user.email = responseObject[@"email"];
                  
                  NSDictionary *stats = responseObject[@"month"];
                  _user.monthSeconds = stats[@"seconds"];
                  _user.monthKm = stats[@"km"];
                  _user.monthRoutes = stats[@"total"];
                  
                  NSString *base64Pic = responseObject[@"profile_pic"];
                  if (base64Pic) {
                      NSData *picData = [[NSData alloc] initWithBase64EncodedString:base64Pic options:0];
                      _user.image = picData;
                  }

                  @weakify(self);
                  [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                      NSLog(@"Saved new user");
                      @strongify(self);
                      [self loadFromUser:_user];
                  }];
                  
                  [subscriber sendCompleted];
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"User load failure");
                  NSLog(@"%@", error);
                  [subscriber sendError:error];
              }
          ];
        
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

@end
