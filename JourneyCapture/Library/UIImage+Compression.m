//
//  UIImage+Compression.m
//  JourneyCapture
//
//  Created by Chris Sloey on 10/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "UIImage+Compression.h"

@implementation UIImage (Compression)

- (NSData *)compressToSize:(int)sizeKb
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = sizeKb*1024;

    NSData *imageData = UIImageJPEGRepresentation(self, compression);

    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }

    return imageData;
}

@end
