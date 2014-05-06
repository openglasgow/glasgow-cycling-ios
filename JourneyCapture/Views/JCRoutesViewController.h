//
//  JCRoutesViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCRoutesListViewModel, JCLoadingView;

@interface JCRoutesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) JCRoutesListViewModel *viewModel;
@property (strong, nonatomic) JCLoadingView *loadingView;
@property (strong, nonatomic) UITableView *routesTableView;

- (id)initWithViewModel:(JCRoutesListViewModel *)routesViewModel;
@end
