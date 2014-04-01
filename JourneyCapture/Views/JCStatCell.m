//
//  JCStatCell.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCStatCell.h"

@implementation JCStatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _statName = [[UILabel alloc] init];
        [self.contentView addSubview:_statName];
        [_statName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView.mas_centerX).with.offset(-5);
        }];

        _statValue = [[UILabel alloc] init];
        [_statValue setTextAlignment:NSTextAlignmentRight];
        [_statValue setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:_statValue];
        [_statValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.left.equalTo(self.contentView.mas_centerX).with.offset(5);;
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
