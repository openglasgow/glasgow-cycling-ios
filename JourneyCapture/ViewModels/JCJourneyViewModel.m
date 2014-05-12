//
//  JCJourneyViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCJourneyViewModel.h"
#import "JCAPIManager.h"
#import "JCPathListViewModel.h"

@implementation JCJourneyViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasChildren = YES;
    }
    return self;
}

- (RACSignal *)readableInstanceCount
{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [RACObserve(self, numInstances) subscribeNext:^(NSNumber *numInstances) {
            [subscriber sendNext:[NSString stringWithFormat:@"%d routes", [numInstances intValue]]];
        }];
        return nil;
    }];
}

@end
