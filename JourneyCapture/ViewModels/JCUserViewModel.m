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
    _menuItems = @[@"My Routes", @"Nearby Routes", @"Glasgow Cycling Map"];
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

-(RACSignal *)fullNameSignal
{
    RACSignal *firstNameSignal = RACObserve(self, firstName);
    RACSignal *lastNameSignal = RACObserve(self, lastName);
    return [[RACSignal combineLatest:@[firstNameSignal, lastNameSignal]] reduceEach:^id{
        return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
    }];
}

-(void)loadFromUser:(User *)userModel
{
    _user = userModel;
    [self setFirstName:_user.firstName];
    [self setLastName:_user.lastName];
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
                                              
                                              // Store in VM
//                                              [self setFirstName:responseObject[@"first_name"]];
//                                              [self setLastName:responseObject[@"last_name"]];
//
//                                              NSDictionary *stats = responseObject[@"month"];
//                                              [self setSecondsThisMonth:stats[@"seconds"]];
//                                              [self setKmThisMonth:stats[@"km"]];
//                                              [self setRoutesThisMonth:stats[@"total"]];
//
//
                                              // Update model
                                              
                                              _user.firstName = responseObject[@"first_name"];
                                              _user.lastName = responseObject[@"last_name"];
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
