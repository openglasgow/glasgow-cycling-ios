//
//  JCRoutesViewController.h
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCRoutesListViewModel;

@interface JCRoutesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) JCRoutesListViewModel *viewModel;

- (id)initWithViewModel:(JCRoutesListViewModel *)routesViewModel;
@end
