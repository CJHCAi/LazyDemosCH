//
//  UIImage+colorless.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/27.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "UIImage+colorless.h"


//CIPhotoEffectTonal


@implementation UIImage (colorless)
- (UIImage *)filterToColorless {
    CIImage *inputCIImage = [[CIImage alloc] initWithImage:self];
    CIFilter *colorlessFilter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
    
    [colorlessFilter setValue:inputCIImage forKey:kCIInputImageKey];
    [colorlessFilter setDefaults];
//    NSLog(@"滤镜详情 %@", colorlessFilter.attributes);
    
    CIImage *outputCIImage = [colorlessFilter valueForKey:kCIOutputImageKey];
    
    //渲染
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    
    //output
    UIImage *outputUIImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return outputUIImage;
}
@end
