//
//  JCSearchView.h
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCLoadingView;

@interface JCSearchView : UIView
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) JCLoadingView *loadingView;
@end
