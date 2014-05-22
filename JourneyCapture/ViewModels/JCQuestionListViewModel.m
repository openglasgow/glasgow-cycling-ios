//
//  JCQuestionListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 04/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCQuestionListViewModel.h"
#import "JCQuestionViewModel.h"
#import "JCAPIManager.h"
#import <GSKeychain/GSKeychain.h>

@implementation JCQuestionListViewModel
@synthesize questions;

- (id)init
{
    self = [super init];
    if (self) {
        JCQuestionViewModel *vm = [[JCQuestionViewModel alloc] init];
        [vm setQuestion:@"How often will you use this app?"];
        [vm setAnswers:@[@"Once a week", @"Twice a week", @"3-5 times a week", @"Daily"]];
        [vm setTitle:@"Your Weekly Usage"];

        JCQuestionViewModel *vm2 = [[JCQuestionViewModel alloc] init];
        [vm2 setQuestion:@"What kind of cycling will you be doing?"];
        [vm2 setAnswers:@[@"Commuting", @"Leisure", @"Family journeys", @"Offroad", @"Other"]];
        [vm2 setTitle:@"Why Do You Cycle"];

        JCQuestionViewModel *vm3 = [[JCQuestionViewModel alloc] init];
        [vm3 setQuestion:@"Why will you be using this app?"];
        [vm3 setAnswers:@[@"Community improvement", @"Health", @"Social", @"Exploration"]];
        [vm3 setTitle:@"Motivation For Cycling"];

        [self setQuestions:@[vm, vm2, vm3]];
    }
    return self;
}

-(RACSignal *)submitResponses
{
    NSLog(@"Loading user");
    JCAPIManager *manager = [JCAPIManager manager];
    JCQuestionViewModel *perWeekQ = self.questions[0];
    JCQuestionViewModel *typeQ = self.questions[1];
    JCQuestionViewModel *reasonQ = self.questions[2];
    NSDictionary *responseParams = @{
                                     @"usage_per_week": perWeekQ.selectedAnswerIndex,
                                     @"usage_type": typeQ.selectedAnswerIndex,
                                     @"usage_reason": reasonQ.selectedAnswerIndex,
                                   };
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager POST:@"/responses.json"
                                        parameters:@{@"responses": responseParams}
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                              NSLog(@"User response submit success");
                                              NSLog(@"%@", responseObject);
                                              [subscriber sendCompleted];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"User response submit failure");
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
