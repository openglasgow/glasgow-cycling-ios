//
//  JCGraphView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCStatViewModel, JBChartView, JCGraphFooterView;

@interface JCGraphView : UIView
@property (strong, nonatomic) JCStatViewModel *viewModel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) JBChartView *graphView;
@property (strong, nonatomic) NSString *displayKey;
@property (strong, nonatomic) JCGraphFooterView *axisView;

- (id)initWithViewModel:(JCStatViewModel *)statViewModel;
- (void)reloadData;
@end
