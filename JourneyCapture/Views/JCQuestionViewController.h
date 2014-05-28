//
//  JCQuestionViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 04/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCQuestionListViewModel, JCQuestionViewModel, JCQuestionView;

@interface JCQuestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UITableView *answersTable;
@property (strong, nonatomic) JCQuestionListViewModel *viewModel;
@property (strong, nonatomic) JCQuestionViewModel *questionModel;
@property (strong, nonatomic) JCQuestionView *questionView;
@property (readwrite, nonatomic) NSInteger questionIndex;

- (void)loadNext;
- (id)initWithViewModel:(JCQuestionListViewModel *)onboardingViewModel questionIndex:(NSInteger)index;
@end
