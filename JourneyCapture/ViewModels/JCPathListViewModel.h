//
// Created by Chris Sloey on 12/05/2014.
// Copyright (c) 2014 FCD. All rights reserved.
//

@import Foundation;

@interface JCPathListViewModel : RVMViewModel
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSString *title;

- (RACSignal *)loadItems;

-(void)storeItems:(NSArray *)allItemData;
@end