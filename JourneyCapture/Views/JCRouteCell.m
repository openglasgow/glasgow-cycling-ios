//
//  JCRouteCell.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCell.h"
#import "JCRouteViewModel.h"
@import QuartzCore;
#import <EDStarRating/EDStarRating.h>

@implementation JCRouteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    UIColor *nameColor = [UIColor blackColor];
    UIColor *secondaryColor = [UIColor colorWithRed:88/255.0f green:77/255.0f blue:77/255.0f alpha:1];
    
    [RACChannelTo(self, viewModel.name) subscribeNext:^(id name) {
        _nameLabel.text = name;
    }];
    _nameLabel.textColor = nameColor;
    
    [RACChannelTo(self, viewModel.totalKm) subscribeNext:^(id distance) {
        _distanceLabel.text = [NSString stringWithFormat:@"%.02f", [distance floatValue]];
    }];
    _distanceLabel.textColor = secondaryColor;
    
    [RACChannelTo(self, viewModel.estimatedTime) subscribeNext:^(id time) {
        _timeLabel.text = [_viewModel readableTime];
    }];
    _timeLabel.textColor = secondaryColor;

    [RACChannelTo(self, viewModel.uses) subscribeNext:^(id uses) {
        _numRoutesLabel.text = [NSString stringWithFormat:@"%d uses", [uses intValue]];
    }];
    _numRoutesLabel.textColor = secondaryColor;
    
    // Rating view
    _starRatingView = [[EDStarRating alloc] initWithFrame:_ratingView.frame];
    [_starRatingView setEditable:NO];
    [_starRatingView setDisplayMode:EDStarRatingDisplayFull];
    _starRatingView.rating = [self.viewModel.averageRating floatValue];
    _starRatingView.starImage = [UIImage imageNamed:@"star-template"];
    _starRatingView.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [_starRatingView setBackgroundColor:[UIColor clearColor]];
    _starRatingView.horizontalMargin = 5;
    [_ratingView addSubview:_starRatingView];
    
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
//    _starRatingView = [[EDStarRating alloc] init];
//    [_starRatingView setEditable:NO];
//    [_starRatingView setDisplayMode:EDStarRatingDisplayFull];
//    _starRatingView.rating = [self.viewModel.averageRating floatValue];
//    _starRatingView.starImage = [UIImage imageNamed:@"star-template"];
//    _starRatingView.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
//    [_starRatingView setBackgroundColor:[UIColor clearColor]];
//    _starRatingView.horizontalMargin = 5;
//    [self.contentView addSubview:_starRatingView];
//
//    [_starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
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
//        make.top.equalTo(_starRatingView.mas_bottom).with.offset(10);
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
