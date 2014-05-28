//
//  JCStatsSummaryView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 23/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCUsageViewModel;

@interface JCStatsSummaryView : UIView

@property (strong, nonatomic) JCUsageViewModel *viewModel;
@property (strong, nonatomic) UILabel *distanceTitleLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *routesCompletedTitleLabel;
@property (strong, nonatomic) UILabel *routesCompletedLabel;

- (id)initWithViewModel:(JCUsageViewModel *)usageViewModel;

@end
