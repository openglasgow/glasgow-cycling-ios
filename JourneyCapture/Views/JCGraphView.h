//
//  JCGraphView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCStatsViewModel, JBChartView;

@interface JCGraphView : UIView
@property (strong, nonatomic) JCStatsViewModel *viewModel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) JBChartView *graphView;

- (id)initWithViewModel:(JCStatsViewModel *)statsViewModel;
- (void)reloadData;
@end
