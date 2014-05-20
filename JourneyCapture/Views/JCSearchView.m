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
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor jc_blueColor]];
        [self addSubview:_searchBar];
        
        // Loading indicator
        _loadingView = [JCLoadingView new];
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        _loadingView.loading = NO;
        [self addSubview:_loadingView];
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
    
    [super layoutSubviews];
}

@end
