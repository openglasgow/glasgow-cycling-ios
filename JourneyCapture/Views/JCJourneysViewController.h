//
//  JCJourneysViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCPathListViewModel, JCLoadingView;

@interface JCJourneysViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) JCPathListViewModel *viewModel;
@property (strong, nonatomic) JCLoadingView *loadingView;
@property (strong, nonatomic) UITableView *routesTableView;

- (id)initWithViewModel:(JCPathListViewModel *)routesViewModel;
@end
