//
//  JCRouteCell.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCell.h"
#import "JCRouteViewModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation JCRouteCell
@synthesize nameLabel, averageRatingLabel, averageRatingView,
            estimatedTimeLabel, estimatedTimeView, distanceLabel, distanceView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
          viewModel:(JCRouteViewModel *)routeViewModel;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self setViewModel:routeViewModel];
    return self;
}

- (void)setViewModel:(JCRouteViewModel *)routeViewModel
{
    self->_viewModel = routeViewModel;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    [self.contentView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 8.0f;
    
    // Name
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue"
                                       size:20.0];
    self.nameLabel = [[UILabel alloc] init];
    [self.nameLabel setFont:nameFont];
    RACChannelTo(self.nameLabel, text) = RACChannelTo(self.viewModel, name);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(12);
    }];
    
    // Details images
    UIImage *safetyImage = [UIImage imageNamed:@"lock-50"];
    self.averageRatingView = [[UIImageView alloc] initWithImage:safetyImage];
    [self.contentView addSubview:self.averageRatingView];
    [self.averageRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
    }];

    UIImage *estimatedTimeImage = [UIImage imageNamed:@"clock-50"];
    self.estimatedTimeView = [[UIImageView alloc] initWithImage:estimatedTimeImage];
    [self.contentView addSubview:self.estimatedTimeView];
    [self.estimatedTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.averageRatingView.mas_bottom).with.offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
    }];
    
    UIImage *distanceImage = [UIImage imageNamed:@"length-50"];
    self.distanceView = [[UIImageView alloc] initWithImage:distanceImage];
    [self.contentView addSubview:self.distanceView];
    [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_bottom).with.offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
    }];
    
    // Details labels
    UIFont *detailsFont = [UIFont fontWithName:@"Helvetica Neue"
                                        size:12.0];
    self.averageRatingLabel = [[UILabel alloc] init];
    [self.averageRatingLabel setFont:detailsFont];
    RACChannelTerminal *averageRatingLabelChannel = RACChannelTo(self, averageRatingLabel.text);
    RACChannelTerminal *averageRatingModelChannel = RACChannelTo(self, viewModel.averageRating);
    [[averageRatingModelChannel map:^(id avgRating){
        return [NSString stringWithFormat:@"%@ stars", avgRating];
    }] subscribe:averageRatingLabelChannel];

    [self.contentView addSubview:self.averageRatingLabel];
    [self.averageRatingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.averageRatingView.mas_top);
        make.left.equalTo(self.averageRatingView.mas_right).with.offset(10);
    }];

    self.estimatedTimeLabel = [[UILabel alloc] init];
    [self.estimatedTimeLabel setFont:detailsFont];
    RACChannelTerminal *estimatedTimeLabelChannel = RACChannelTo(self, estimatedTimeLabel.text);
    RACChannelTerminal *estimatedTimeModelChannel = RACChannelTo(self, viewModel.estimatedTime);
    [[estimatedTimeModelChannel map:^(id estSeconds){
        return [self.viewModel readableTime];
    }] subscribe:estimatedTimeLabelChannel];
    [self.contentView addSubview:self.estimatedTimeLabel];
    [self.estimatedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_top);
        make.left.equalTo(self.estimatedTimeView.mas_right).with.offset(10);
    }];

    self.distanceLabel = [[UILabel alloc] init];
    [self.distanceLabel setFont:detailsFont];
    RACChannelTerminal *distanceLabelChannel = RACChannelTo(self, distanceLabel.text);
    RACChannelTerminal *distanceModelChannel = RACChannelTo(self, viewModel.distanceMetres);
    [[distanceModelChannel map:^(id meters){
        float km = [meters intValue]/1000.0;
        return [NSString stringWithFormat:@"%.02f km", km];
    }] subscribe:distanceLabelChannel];

    [self.contentView addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceView.mas_top);
        make.left.equalTo(self.distanceView.mas_right).with.offset(10);
    }];

    // Background image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:self.viewModel.routeImage];
    self.backgroundView = backgroundImageView;
//    cell.backgroundView = [ [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_normal.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ]autorelease];
//    cell.selectedBackgroundView = [ [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell_pressed.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ]autorelease];
//    
//    UIColor *background = [UIColor colorWithPatternImage:self.viewModel.routeImage];
//    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//    [self.backgroundView setBackgroundColor:[UIColor redColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
