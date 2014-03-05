//
//  JCQuestionViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 04/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCQuestionViewController.h"
#import "JCQuestionListViewModel.h"
#import "JCQuestionViewModel.h"
#import "JCUserViewController.h"

@interface JCQuestionViewController ()

@end

@implementation JCQuestionViewController
@synthesize questionLabel, answersTable, viewModel, tableViewHeight, questionIndex, questionModel;

- (id)initWithViewModel:(JCQuestionListViewModel *)onboardingViewModel questionIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.viewModel = onboardingViewModel;
        self.questionModel = self.viewModel.questions[index];
        self.questionIndex = index;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Question
    self.questionLabel = [[UILabel alloc] init];
    [self.questionLabel setText:self.questionModel.question];
    [self.view addSubview:self.questionLabel];
    int navBarHeight = self.navigationController.navigationBar.frame.size.height;
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(navBarHeight + 20 + 15); // 20 for statusbar
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(15);
    }];

    // Answers
    self.answersTable = [[UITableView alloc] init];
    [self.answersTable setDelegate:self];
    [self.answersTable setDataSource:self];
    [self.view addSubview:self.answersTable];
    [self.answersTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        self.tableViewHeight = make.height.equalTo(@(250));
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:self.questionModel.title];
    [self.navigationItem setHidesBackButton:YES];
    [self.tableViewHeight uninstall];
    [self.answersTable mas_updateConstraints:^(MASConstraintMaker *make) {
        self.tableViewHeight = make.height.equalTo(@(self.questionModel.answers.count * 34.0));
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.questionModel answers] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"questionCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell textLabel] setText:self.questionModel.answers[indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.questionModel setSelectedAnswerIndex:@(indexPath.row)];
    if (self.questionIndex < self.viewModel.questions.count-1) {
        JCQuestionViewController *nextQuestionVC = [[JCQuestionViewController alloc]
                                                    initWithViewModel:self.viewModel
                                                    questionIndex:(questionIndex + 1)];
        [self.navigationController pushViewController:nextQuestionVC animated:YES];
    } else {
        [[self.viewModel submitResponses] subscribeNext:^(id x) {
            NSLog(@"Responses::next");
        } error:^(NSError *error) {
            NSLog(@"Responses::error");
        } completed:^{
            NSLog(@"Responses::completed");
            JCUserViewController *userController = [[JCUserViewController alloc] init];
            [self.navigationController pushViewController:userController animated:YES];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

@end
