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
#import "Flurry.h"

@interface JCQuestionViewController ()

@end

@implementation JCQuestionViewController

- (id)initWithViewModel:(JCQuestionListViewModel *)onboardingViewModel questionIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _viewModel = onboardingViewModel;
        _questionModel = _viewModel.questions[index];
        _questionIndex = index;
    }
    return self;
}

- (void)loadView
{
    [Flurry logEvent:@"User responses started" withParameters:nil timed:YES];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Question
    _questionLabel = [[UILabel alloc] init];
    _questionLabel.text = _questionModel.question;
    _questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_questionLabel];

    // Answers
    _answersTable = [[UITableView alloc] init];
    _answersTable.delegate = self;
    _answersTable.dataSource = self;
    _answersTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_answersTable];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [_questionLabel autoRemoveConstraintsAffectingView];
    [_questionLabel autoPinToTopLayoutGuideOfViewController:self withInset:15];
    [_questionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15];
    [_questionLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15];

    [_answersTable autoRemoveConstraintsAffectingView];
    [_answersTable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_questionLabel withOffset:15];
    [_answersTable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_answersTable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_answersTable autoSetDimension:ALDimensionHeight toSize:_questionModel.answers.count * 34.0];

    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:_questionModel.title];
    [self.navigationItem setHidesBackButton:YES];
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
    return [[_questionModel answers] count];
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
    [[cell textLabel] setText:_questionModel.answers[indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [_questionModel setSelectedAnswerIndex:@(indexPath.row)];
    if (_questionIndex < _viewModel.questions.count-1) {
        JCQuestionViewController *nextQuestionVC = [[JCQuestionViewController alloc]
                                                    initWithViewModel:_viewModel
                                                    questionIndex:(_questionIndex + 1)];
        [self.navigationController pushViewController:nextQuestionVC animated:YES];
    } else {
        [Flurry endTimedEvent:@"User responses started" withParameters:nil];
        
        [[_viewModel submitResponses] subscribeNext:^(id x) {
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
