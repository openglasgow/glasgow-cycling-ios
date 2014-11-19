//
//  JCQuestionViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 04/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCQuestionViewController.h"
#import "JCUserViewController.h"
#import "JCQuestionListViewModel.h"
#import "JCQuestionViewModel.h"
#import "JCQuestionView.h"

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

#pragma mark - UIViewController

- (void)loadView
{
    CLS_LOG(@"Started user responses VC");
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    JCQuestionViewModel *questionVM = _viewModel.questions[_questionIndex];
    _questionView = [[JCQuestionView alloc] initWithViewModel:questionVM];
    _questionView.translatesAutoresizingMaskIntoConstraints = NO;
    _questionView.answersTable.delegate = self;
    _questionView.answersTable.dataSource = self;
    [self.view addSubview:_questionView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [_questionView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_questionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:_questionModel.title];
    
    if (_questionIndex == 0) {
        [self.navigationItem setHidesBackButton:YES];
    }
    
    _questionView.skipButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_questionModel setSelectedAnswerIndex:@(-1)];
        [self loadNext];
        return [RACSignal empty];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadNext
{
    if (_questionIndex < _viewModel.questions.count-1) {
        JCQuestionViewController *nextQuestionVC = [[JCQuestionViewController alloc]
                                                    initWithViewModel:_viewModel
                                                    questionIndex:(_questionIndex + 1)];
        [self.navigationController pushViewController:nextQuestionVC animated:YES];
    } else {
        CLS_LOG("Submitting responses");
        
        [[_viewModel submitResponses] subscribeNext:^(id x) {
            NSLog(@"Responses::next");
        } error:^(NSError *error) {
            CLS_LOG("Error submitting responses");
        } completed:^{
            CLS_LOG("Success submitting responses");
            JCUserViewController *userController = [[JCUserViewController alloc] init];
            [self.navigationController pushViewController:userController animated:YES];
        }];
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [_questionModel setSelectedAnswerIndex:@(indexPath.row)];
    [self loadNext];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - UITableViewDataSource

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

@end
