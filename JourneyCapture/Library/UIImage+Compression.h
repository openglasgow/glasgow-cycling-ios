//
//  UIImage+Compression.h
//  JourneyCapture
//
//  Created by Chris Sloey on 10/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)
- (NSData *)compressToSize:(int)sizeKb;
@end
