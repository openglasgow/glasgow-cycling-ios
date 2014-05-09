//
//  JCJourneyCell.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCJourneyCell.h"
#import "JCPathViewModel.h"
@import QuartzCore;
#import <EDStarRating/EDStarRating.h>

@implementation JCJourneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    
    return self;
}

- (void)setViewModel:(JCPathViewModel *)viewModel
{
    self->_viewModel = viewModel;
    
    UIColor *nameColor = [UIColor blackColor];
    UIColor *secondaryColor = [UIColor colorWithRed:88/255.0f green:77/255.0f blue:77/255.0f alpha:1];
    
    // Link labels with VM
    [RACChannelTo(self, viewModel.name) subscribeNext:^(id name) {
        _nameLabel.text = name;
    }];
    _nameLabel.textColor = nameColor;
    
    [RACChannelTo(self, viewModel.averageMiles) subscribeNext:^(id distance) {
        _distanceLabel.text = [NSString stringWithFormat:@"%.02f", [distance floatValue]];
    }];
    _distanceLabel.textColor = secondaryColor;
    
    [RACChannelTo(self, viewModel.time) subscribeNext:^(id time) {
        _timeLabel.text = [_viewModel readableTime];
    }];
    _timeLabel.textColor = secondaryColor;

    [viewModel.readableInstanceCount subscribeNext:^(NSString *instanceCount) {
        _numRoutesLabel.text = instanceCount;
    }];
    _numRoutesLabel.textColor = secondaryColor;
    
    // Rating view
    [_ratingView setEditable:NO];
    [_ratingView setDisplayMode:EDStarRatingDisplayFull];
    _ratingView.starImage = [UIImage imageNamed:@"star"];
    _ratingView.starHighlightedImage = [UIImage imageNamed:@"filled-star"];
    
    [RACChannelTo(self, viewModel.averageRating) subscribeNext:^(id rating) {
        _ratingView.rating = [rating floatValue];
    }];
    
    [RACChannelTo(self, viewModel.numReviews) subscribeNext:^(id numReviews) {
        _numReviewsLabel.text = [NSString stringWithFormat:@"(%d)", [numReviews intValue]];
    }];
    _numReviewsLabel.textColor = secondaryColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
