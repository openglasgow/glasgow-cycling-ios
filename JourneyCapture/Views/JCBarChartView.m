//
//  JCBarChartView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCBarChartView.h"
#import "JCStatViewModel.h"

@implementation JCBarChartView

- (id)initWithViewModel:(JCStatViewModel *)statsViewModel
{
    self = [super initWithViewModel:statsViewModel];
    if (self) {
        JBBarChartView *barChartView = [JBBarChartView new];
        barChartView.delegate = self;
        barChartView.dataSource = self;
        barChartView.translatesAutoresizingMaskIntoConstraints = NO;
        barChartView.frame = CGRectMake(0, 0, 320, 250);
        barChartView.minimumValue = 0;
        barChartView.showsVerticalSelection = NO;
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
    return [self.viewModel countOfStats];
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    return [self.viewModel statValueAtIndex:index];
}

@end
