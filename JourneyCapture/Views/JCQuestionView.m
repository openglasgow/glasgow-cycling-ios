//
//  JCQuestionView.m
//  JourneyCapture
//
//  Created by Michael Hayes on 22/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCQuestionView.h"

@implementation JCQuestionView

- (id)initWithViewModel:(JCQuestionViewModel *)questionViewModel
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _viewModel = questionViewModel;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // Content scroll view
    _contentView = [UIScrollView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: _contentView];
    
    _informationArea = [UIView new];
    _informationArea.backgroundColor = [UIColor jc_blueColor];
    _informationArea.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_informationArea];

    _informationLabel = [UILabel new];
    _informationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _informationLabel.text = _viewModel.information;
    _informationLabel.numberOfLines = 4;
    _informationLabel.textAlignment = NSTextAlignmentCenter;
    _informationLabel.textColor = [UIColor whiteColor];
    [_informationArea addSubview:_informationLabel];
    
    _informationImage = [UIImageView new];
    _informationImage.translatesAutoresizingMaskIntoConstraints = NO;
    _informationImage.image = [UIImage imageNamed:@"information-icon"];
    [_informationArea addSubview:_informationImage];
    
    // Question
    _questionLabel = [[UILabel alloc] init];
    _questionLabel.text = _viewModel.question;
    _questionLabel.numberOfLines = 4;
    _questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentView addSubview:_questionLabel];
    
    // Answers
    _answersTable = [[UITableView alloc] init];
    _answersTable.translatesAutoresizingMaskIntoConstraints = NO;
    _answersTable.scrollEnabled = NO;
    [_contentView addSubview:_answersTable];
    
    // Skip
    _skipButton = [UIButton new];
    _skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_skipButton setTitle:@"Skip Question" forState:UIControlStateNormal];
    [_skipButton setBackgroundColor:[UIColor jc_blueColor]];
    [_skipButton setTintColor:[UIColor whiteColor]];
    _skipButton.layer.masksToBounds = YES;
    _skipButton.layer.cornerRadius = 4.0f;
    [_contentView addSubview:_skipButton];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [_informationArea autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_contentView];
    [_informationArea autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView];
    [_informationArea autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView];
    [_informationArea autoSetDimension:ALDimensionHeight toSize:213];

    [_informationImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_informationArea withOffset:15];
    [_informationImage autoSetDimensionsToSize:CGSizeMake(60, 60)];
    [_informationImage autoAlignAxis:ALAxisVertical toSameAxisOfView:_informationArea];
    
    [_informationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_informationImage withOffset:30];
    [_informationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_informationArea withOffset:15];
    [_informationLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_informationArea withOffset:-15];
    
    [_questionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_informationArea withOffset:15];
    [_questionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:15];
    [_questionLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-15];
    [_questionLabel autoSetDimension:ALDimensionHeight toSize:44];
    
    [_answersTable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_questionLabel withOffset:15];
    [_answersTable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView];
    [_answersTable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView];
    [_answersTable autoSetDimension:ALDimensionHeight toSize:_viewModel.answers.count * 34.0];
    
    [_skipButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_answersTable withOffset:15];
    [_skipButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_contentView withOffset:10];
    [_skipButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_contentView withOffset:-10];
    [_skipButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_contentView withOffset:-10];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [_skipButton autoSetDimension:ALDimensionWidth toSize:screenWidth - 20];

    [super layoutSubviews];
}

@end
