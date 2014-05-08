//
//  JCRouteCell.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCell.h"
#import "JCJourneyViewModel.h"
@import QuartzCore;
#import <EDStarRating/EDStarRating.h>

@implementation JCRouteCell

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

- (void)setViewModel:(JCJourneyViewModel *)viewModel
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
    
    [RACChannelTo(self, viewModel.averageTime) subscribeNext:^(id time) {
        _timeLabel.text = [_viewModel readableTime];
    }];
    _timeLabel.textColor = secondaryColor;

    [RACChannelTo(self, viewModel.numRoutes) subscribeNext:^(id numRoutes) {
        _numRoutesLabel.text = [NSString stringWithFormat:@"%d uses", [numRoutes intValue]];
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

//- (void)setViewModel:(JCRouteViewModel *)routeViewModel
//{
//    self->_viewModel = routeViewModel;
//    for(UIView *view in self.contentView.subviews){
//        if ([view respondsToSelector:@selector(removeFromSuperview)]) {
//            [view removeFromSuperview];
//        }
//    }
//
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(10);
//        make.left.equalTo(self.mas_left).with.offset(15);
//        make.right.equalTo(self.mas_right).with.offset(-15);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
//    }];
//    
//    [self.contentView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
//    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.cornerRadius = 8.0f;
//    
//    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue"
//                                       size:17.0];
//    UIFont *detailsFont = [UIFont fontWithName:@"Helvetica Neue"
//                                          size:12.0];
//
//    // Name
//    self.nameLabel = [[UILabel alloc] init];
//    [self.nameLabel setFont:nameFont];
//    self.nameLabel.adjustsFontSizeToFitWidth = YES;
//    self.nameLabel.minimumScaleFactor = 0.75;
//    self.nameLabel.numberOfLines = 1;
//    RACChannelTo(self.nameLabel, text) = RACChannelTo(self.viewModel, name);
//    [self.contentView addSubview:self.nameLabel];
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).with.offset(15);
//        make.top.equalTo(self.contentView.mas_top).with.offset(12);
//        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
//    }];
//    
//    // Average Rating
//    _ratingView = [[EDStarRating alloc] init];
//    [_ratingView setEditable:NO];
//    [_ratingView setDisplayMode:EDStarRatingDisplayFull];
//    _ratingView.rating = [self.viewModel.averageRating floatValue];
//    _ratingView.starImage = [UIImage imageNamed:@"star-template"];
//    _ratingView.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
//    [_ratingView setBackgroundColor:[UIColor clearColor]];
//    _ratingView.horizontalMargin = 5;
//    [self.contentView addSubview:_ratingView];
//
//    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(self.nameLabel.mas_left).with.offset(-5);
//        make.width.equalTo(@95);
//        make.height.equalTo(@16);
//    }];
//
//    // Estimated Time
//    UIImage *estimatedTimeImage = [UIImage imageNamed:@"clock-50"];
//    self.estimatedTimeView = [[UIImageView alloc] initWithImage:estimatedTimeImage];
//    [self.contentView addSubview:self.estimatedTimeView];
//    [self.estimatedTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_ratingView.mas_bottom).with.offset(10);
//        make.left.equalTo(self.nameLabel.mas_left);
//        make.width.equalTo(@12);
//        make.height.equalTo(@12);
//    }];
//
//    self.estimatedTimeLabel = [[UILabel alloc] init];
//    [self.estimatedTimeLabel setFont:detailsFont];
//    RACChannelTerminal *estimatedTimeLabelChannel = RACChannelTo(self, estimatedTimeLabel.text);
//    RACChannelTerminal *estimatedTimeModelChannel = RACChannelTo(self, viewModel.estimatedTime);
//    [[estimatedTimeModelChannel map:^(id estSeconds){
//        return [self.viewModel readableTime];
//    }] subscribe:estimatedTimeLabelChannel];
//    [self.contentView addSubview:self.estimatedTimeLabel];
//    [self.estimatedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.estimatedTimeView.mas_top);
//        make.left.equalTo(self.estimatedTimeView.mas_right).with.offset(10);
//    }];
//
//    // Distance
//    UIImage *distanceImage = [UIImage imageNamed:@"length-50"];
//    self.distanceView = [[UIImageView alloc] initWithImage:distanceImage];
//    [self.contentView addSubview:self.distanceView];
//    [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.estimatedTimeView.mas_bottom).with.offset(10);
//        make.left.equalTo(self.nameLabel.mas_left);
//        make.width.equalTo(@12);
//        make.height.equalTo(@12);
//    }];
//    
//    self.distanceLabel = [[UILabel alloc] init];
//    [self.distanceLabel setFont:detailsFont];
//    RACChannelTerminal *distanceLabelChannel = RACChannelTo(self, distanceLabel.text);
//    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.totalKm);
//    [[distanceModelChannel map:^(id km){
//        return [NSString stringWithFormat:@"%.02f km", self.viewModel.totalKm];
//    }] subscribe:distanceLabelChannel];
//
//    [self.contentView addSubview:self.distanceLabel];
//    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.distanceView.mas_top);
//        make.left.equalTo(self.distanceView.mas_right).with.offset(10);
//    }];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
