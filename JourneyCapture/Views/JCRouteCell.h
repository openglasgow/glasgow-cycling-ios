//
//  JCRouteCell.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCRouteViewModel, EDStarRating;

@interface JCRouteCell : UITableViewCell

@property (strong, nonatomic, setter = setViewModel:) JCRouteViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) EDStarRating *starRatingView;
@property (weak, nonatomic) IBOutlet UIView *ratingView; // container
@property (strong, nonatomic) EDStarRating *averageRating;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRoutesLabel;

- (void)commonInit;

@end
