//
//  JCTextField.h
//  JourneyCapture
//
//  Created by Chris Sloey on 12/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCTextField : UITextField
@property (readwrite, nonatomic) BOOL valid;
@property (strong, nonatomic) UIView *invalidView;

@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) UILabel *errorLabel;

@property (strong, nonatomic) UIColor *correctBorderColor;
@property (readwrite, nonatomic) float correctBorderWidth;
@property (readwrite, nonatomic) float correctCornerRadius;
@property (strong, nonatomic) UIColor *errorBorderColor;

-(void)showError;
-(void)hideError;

-(void)showInvalid;
-(void)hideInvalid;
@end
