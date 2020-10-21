//
//  GCImageData.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 6/7/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCImageData.h"

@implementation GCImageData

@synthesize data, extension;

- (id)initWithData:(NSData *)_data extension:(NSString *)_extension
{
    self = [super init];
    if (self) {
        self.data = _data;
        self.extension = _extension;
    }
    return self;
}

+ (instancetype)imageData:(NSData *)data extension:(NSString *)extension
{
    return [[GCImageData alloc] initWithData:data extension:extension];
}

+ (instancetype)dataWithUIImage:(UIImage *)image
{
    CGImageAlphaInfo imgAlpha = CGImageGetAlphaInfo(image.CGImage);
    GCImageData *imageData;
    NSString *ext;
    
    // Is this an image with transparency (i.e. do we need to save as PNG?)
    if ((imgAlpha == kCGImageAlphaNone) || (imgAlpha == kCGImageAlphaNoneSkipFirst) || (imgAlpha == kCGImageAlphaNoneSkipLast)) {
        // save as a JPEG
        ext = @"JPEG";
        imageData = [GCImageData imageData:UIImageJPEGRepresentation(image, 1.0) extension:ext];
    } else {
        // save as a PNG
        ext = @"PNG";
        imageData = [GCImageData imageData:UIImagePNGRepresentation(image) extension:ext];
    }
    return imageData;
}

@end
