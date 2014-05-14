//
// Created by Chris Sloey on 12/05/2014.
// Copyright (c) 2014 FCD. All rights reserved.
//

@import Foundation;
@class JCPathViewModel;

@interface JCPathListViewModel : RVMViewModel
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *noItemsError;
@property (readwrite, nonatomic) NSInteger currentPage;
@property (readwrite, nonatomic) NSInteger perPage;

- (NSDictionary *)searchParams;
- (RACSignal *)loadItems;

-(void)storeItems:(NSArray *)allItemData;
-(void)storeItem:(NSDictionary *)itemData inViewModel:(JCPathViewModel *)pathVM;
@end