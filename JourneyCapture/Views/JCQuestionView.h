//
//  JCQuestionView.h
//  JourneyCapture
//
//  Created by Michael Hayes on 22/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCQuestionListViewModel.h"
#import "JCQuestionViewModel.h"

@interface JCQuestionView : UIView

@property (strong, nonatomic) JCQuestionViewModel *viewModel;
@property (strong, nonatomic) UIScrollView *contentView;

@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UITableView *answersTable;
@property (strong, nonatomic) UIButton *skipButton;

//Blue area at top of view
@property (strong, nonatomic) UIView *informationArea;
@property (strong, nonatomic) UILabel *informationLabel;
@property (strong, nonatomic) UIImageView *informationImage;

- (id)initWithViewModel:(JCQuestionViewModel *)questionViewModel;
@end
