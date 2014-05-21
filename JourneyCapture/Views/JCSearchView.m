//
//  JCSearchView.m
//  JourneyCapture
//
//  Created by Michael Hayes on 19/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCSearchView.h"
#import "UIImage+color.h"
#import "JCLoadingView.h"

@implementation JCSearchView

- (id)init
{
    self = [super init];
    if (self) {
        _searchBar = [UISearchBar new];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor jc_blueColor]];
        [self addSubview:_searchBar];
        
        // Loading indicator
        _loadingView = [JCLoadingView new];
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        _loadingView.loading = NO;
        [self addSubview:_loadingView];
        
        // Results table
        _resultsTableView = [UITableView new];
        _resultsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_resultsTableView];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [_searchBar autoRemoveConstraintsAffectingView];
    [_searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    [_loadingView autoRemoveConstraintsAffectingView];
    [_loadingView autoCenterInSuperview];
    [_loadingView layoutSubviews];
    
    [_resultsTableView autoRemoveConstraintsAffectingView];
    [_resultsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                excludingEdge:ALEdgeTop];
    [_resultsTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_searchBar];
    
    [super layoutSubviews];
}

@end
