//
//  JCLoadingView.h
//  JourneyCapture
//
//  Created by Chris Sloey on 01/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCLoadingView : UIView
@property (readwrite, nonatomic) BOOL loading;

@property (strong, nonatomic) UIView *cyclistView;
@property (strong, nonatomic) UIImageView *bikeFrame;
@property (strong, nonatomic) UIImageView *backWheel;
@property (strong, nonatomic) UIImageView *frontWheel;

@property (strong, nonatomic) UILabel *infoLabel;
@end
