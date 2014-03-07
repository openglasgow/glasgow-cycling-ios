//
//  JCRouteCell.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCRouteViewModel, EDStarRating;

@interface JCRouteCell : UITableViewCell

@property (strong, nonatomic, setter = setViewModel:) JCRouteViewModel *viewModel;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) EDStarRating *averageRating;

@property (strong, nonatomic) UIImageView *estimatedTimeView;
@property (strong, nonatomic) UILabel *estimatedTimeLabel;

@property (strong, nonatomic) UIImageView *distanceView;
@property (strong, nonatomic) UILabel *distanceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
          viewModel:(JCRouteViewModel *)routeViewModel;

@end
