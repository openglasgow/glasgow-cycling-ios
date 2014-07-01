//
//  JCJourneyCell.h
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

@import UIKit;
@class JCPathViewModel, EDStarRating;

@interface JCPathCell : UITableViewCell

@property (strong, nonatomic, setter = setViewModel:) JCPathViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet EDStarRating *ratingView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numRoutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numReviewsLabel;

@end
