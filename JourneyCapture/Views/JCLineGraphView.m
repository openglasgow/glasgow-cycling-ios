//
//  JCLineGraphView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCLineGraphView.h"
#import "JCStatViewModel.h"
#import "JCGraphFooterView.h"

@implementation JCLineGraphView

- (id)initWithViewModel:(JCStatViewModel *)statsViewModel
{
    self = [super initWithViewModel:statsViewModel];
    if (self) {
        JBLineChartView *lineChartView = [JBLineChartView new];
        lineChartView.delegate = self;
        lineChartView.dataSource = self;
        lineChartView.translatesAutoresizingMaskIntoConstraints = NO;
        lineChartView.frame = CGRectMake(0, 0, 320, 250);
        lineChartView.minimumValue = 0;
        lineChartView.showsLineSelection = NO;
        lineChartView.showsVerticalSelection = NO;
        UIImage *footerImage = [UIImage imageNamed:@"week-axis"];
        JCGraphFooterView *axisView = [[JCGraphFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 37) image:footerImage];
        lineChartView.footerView = axisView;
        [self.graphView removeFromSuperview];
        self.graphView = lineChartView;
        [self addSubview:self.graphView];
    }
    return self;
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [self.viewModel countOfStats];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex
{
    CGFloat distanceKm = [self.viewModel statValueAtIndex:horizontalIndex];
    NSLog(@"Selected stat value: %f", distanceKm);
    self.titleLabel.text = [NSString stringWithFormat:@"%.1f miles", distanceKm * 0.621371192f];
}

- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    self.titleLabel.text = self.viewModel.title;
}

#pragma mark - JBLineChartViewDelegate

-(CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
            atLineIndex:(NSUInteger)lineIndex
{
    return [self.viewModel statValueAtIndex:horizontalIndex];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor jc_blueColor];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 4.0f;
}

-(BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

@end
