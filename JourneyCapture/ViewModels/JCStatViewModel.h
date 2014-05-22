//
//  JCStatViewModel.h
//  JourneyCapture
//
//  Created by Chris Sloey on 21/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "RVMViewModel.h"
@class JCUsageViewModel;


@interface JCStatViewModel : RVMViewModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *displayKey;
@property (strong, nonatomic) JCUsageViewModel *stats;

- (instancetype)initWithUsage:(JCUsageViewModel *)usageViewModel
                   displayKey:(NSString *)displayKey title:(NSString *)title;
- (NSInteger)countOfStats;
- (CGFloat)statValueAtIndex:(NSUInteger)index;
- (NSString *)statDisplayStringForIndex:(NSUInteger)index;

@end
