//
//  JCBarChartView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCBarChartView.h"
#import "JCStatViewModel.h"
#import "JCGraphFooterView.h"

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
        UIImage *footerImage = [UIImage imageNamed:@"week-axis"];
        JCGraphFooterView *axisView = [[JCGraphFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 37) image:footerImage];
        barChartView.footerView = axisView;
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

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index
{
    NSString *value = [self.viewModel statDisplayStringForIndex:index];
    NSString *day = [self.viewModel dayForIndex:index];
    self.titleLabel.text = [NSString stringWithFormat:@"%@: %@", day, value];}

- (void)didUnselectBarChartView:(JBBarChartView *)barChartView
{
    [self resetText];
}

#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return [self.viewModel countOfStats];
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    return [self.viewModel statValueAtIndex:index];
}

@end
