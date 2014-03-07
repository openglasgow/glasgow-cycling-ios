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
#import <EDStarRating/EDStarRating.h>

@implementation JCRouteCell
@synthesize nameLabel, averageRating,
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
    
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue"
                                       size:20.0];
    UIFont *detailsFont = [UIFont fontWithName:@"Helvetica Neue"
                                          size:12.0];

    // Name
    self.nameLabel = [[UILabel alloc] init];
    [self.nameLabel setFont:nameFont];
    RACChannelTo(self.nameLabel, text) = RACChannelTo(self.viewModel, name);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(12);
    }];
    
    // Average Rating
    self.averageRating = [[EDStarRating alloc] init];
    [self.averageRating setEditable:NO];
    [self.averageRating setDisplayMode:EDStarRatingDisplayFull];
    self.averageRating.rating = [self.viewModel.averageRating floatValue];
    self.averageRating.starImage = [UIImage imageNamed:@"star-template"];
    self.averageRating.starHighlightedImage = [UIImage imageNamed:@"star-highlighted-template"];
    [self.averageRating setBackgroundColor:[UIColor clearColor]];
    self.averageRating.horizontalMargin = 5;
    [self.contentView addSubview:self.averageRating];

    [self.averageRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.nameLabel.mas_left).with.offset(-5);
        make.width.equalTo(@95);
        make.height.equalTo(@16);
    }];

    // Estimated Time
    UIImage *estimatedTimeImage = [UIImage imageNamed:@"clock-50"];
    self.estimatedTimeView = [[UIImageView alloc] initWithImage:estimatedTimeImage];
    [self.contentView addSubview:self.estimatedTimeView];
    [self.estimatedTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.averageRating.mas_bottom).with.offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
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

    // Distance
    UIImage *distanceImage = [UIImage imageNamed:@"length-50"];
    self.distanceView = [[UIImageView alloc] initWithImage:distanceImage];
    [self.contentView addSubview:self.distanceView];
    [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedTimeView.mas_bottom).with.offset(10);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(12));
        make.height.equalTo(@(12));
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
