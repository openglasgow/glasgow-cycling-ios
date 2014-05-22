//
//  JCGraphScrollView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 21/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
#import "JCUsageViewModel.h"

@interface JCGraphScrollView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) JCUsageViewModel *viewModel;
@property (strong, nonatomic) UIScrollView *statsScrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *graphViews;

- (id)initWithFrame:(CGRect)frame viewModel:(JCUsageViewModel *)usageViewModel;
- (void)pageChanged;

@end
