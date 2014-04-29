//
//  JCMenuTableViewCell.m
//  JourneyCapture
//
//  Created by Chris Sloey on 29/04/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCMenuTableViewCell.h"

@implementation JCMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
