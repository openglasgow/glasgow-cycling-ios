//
//  JCBarChartView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCBarChartView.h"
#import "JCStatsViewModel.h"

@implementation JCBarChartView

- (id)initWithViewModel:(JCStatsViewModel *)statsViewModel
{
    self = [super initWithViewModel:statsViewModel];
    if (self) {
        JBBarChartView *barChartView = [JBBarChartView new];
        barChartView.delegate = self;
        barChartView.dataSource = self;
        barChartView.translatesAutoresizingMaskIntoConstraints = NO;
        barChartView.frame = CGRectMake(0, 0, 320, 400);
        [self.graphView removeFromSuperview];
        self.graphView = barChartView;
        [self addSubview:self.graphView];
    }
    return self;
}

#pragma mark - JBBarChartViewDelegate

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return [UIColor jc_mediumBlueColor];
}

#pragma mark - JBBarChartViewDataSource

-(NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.viewModel.periods.count;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    return [self.viewModel.periods[index] floatValue];
}

@end
