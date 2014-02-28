//
//  JCRouteCell.m
//  JourneyCapture
//
//  Created by Chris Sloey on 28/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCell.h"
#import "JCRouteViewModel.h"

@implementation JCRouteCell
@synthesize nameLabel, safetyRatingLabel, safetyRatingView, lastUsedLabel, lastUsedView,
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
    
    // Name
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue"
                                       size:17.0];
    self.nameLabel = [[UILabel alloc] init];
    [self.nameLabel setFont:nameFont];
    [self.nameLabel setText:self.viewModel.name];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
    }];
    
    // Details images
    UIImage *safetyImage = [UIImage imageNamed:@"lock-50"];
    self.safetyRatingView = [[UIImageView alloc] initWithImage:safetyImage];
    [self.contentView addSubview:self.safetyRatingView];
    [self.safetyRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
    }];
    
    UIImage *lastUsedImage = [UIImage imageNamed:@"calendar-50"];
    self.lastUsedView = [[UIImageView alloc] initWithImage:lastUsedImage];
    [self.contentView addSubview:self.lastUsedView];
    [self.lastUsedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyRatingView.mas_bottom).with.offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
    }];
    
    UIImage *estimatedTimeImage = [UIImage imageNamed:@"clock-50"];
    self.estimatedTimeView = [[UIImageView alloc] initWithImage:estimatedTimeImage];
    [self.contentView addSubview:self.estimatedTimeView];
    [self.estimatedTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastUsedView.mas_bottom).with.offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
    }];
    
    UIImage *distanceImage = [UIImage imageNamed:@"length-50"];
    self.distanceView = [[UIImageView alloc] initWithImage:distanceImage];
    [self.contentView addSubview:self.distanceView];
    [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_bottom).with.offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
    }];
    
    // Details labels
    UIFont *detailsFont = [UIFont fontWithName:@"Helvetica Neue"
                                          size:11.0];
    self.safetyRatingLabel = [[UILabel alloc] init];
    [self.safetyRatingLabel setFont:detailsFont];
    [self.safetyRatingLabel setText:self.viewModel.safetyRating];
    [self.contentView addSubview:self.safetyRatingLabel];
    [self.safetyRatingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safetyRatingView.mas_top);
        make.left.equalTo(self.safetyRatingView.mas_right).with.offset(10);
    }];

    self.lastUsedLabel = [[UILabel alloc] init];
    [self.lastUsedLabel setFont:detailsFont];
    [self.lastUsedLabel setText:self.viewModel.lastUsed];
    [self.contentView addSubview:self.lastUsedLabel];
    [self.lastUsedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastUsedView.mas_top);
        make.left.equalTo(self.lastUsedView.mas_right).with.offset(10);
    }];

    self.estimatedTimeLabel = [[UILabel alloc] init];
    [self.estimatedTimeLabel setFont:detailsFont];
    [self.estimatedTimeLabel setText:self.viewModel.estimatedTime];
    [self.contentView addSubview:self.estimatedTimeLabel];
    [self.estimatedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_top);
        make.left.equalTo(self.estimatedTimeView.mas_right).with.offset(10);
    }];
    
    self.distanceLabel = [[UILabel alloc] init];
    [self.distanceLabel setFont:detailsFont];
    [self.distanceLabel setText:self.viewModel.distanceKm];
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
