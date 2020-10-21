//
//  LMFilterGroup.m
//  Test1030
//
//  Created by xx11dragon on 15/11/4.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import "LMFilterGroup.h"
#import <objc/runtime.h>
#import "GPUImage.h"

@implementation LMFilterGroup{
    UIImage * _image;
}

//-(UIImage *)effectIcon{
//    @synchronized (self) {
//        if (!_image) {
//            _image =[LMFilterGroup generateEffectImage:self];
//            [self saveImage:_image name:self.title];
//        }
//        
//        return _image;
//    }
//}

+(UIImage *) generateEffectImage:(GPUImageFilterGroup *)filter{
    GPUImagePicture * gpuPicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"filter_no_effect"]];
    [gpuPicture addTarget:filter];
    
    // 开始处理图片
    [filter useNextFrameForImageCapture];
    [gpuPicture processImage];
    
    // 输出处理后的图片
    UIImage *outputImage = [filter imageFromCurrentFramebuffer];

    [gpuPicture removeTarget:filter];
    
    return outputImage;
}


-(NSString *)storePath{
    static NSString * _path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        _path = [paths[0] stringByAppendingPathComponent:@"Photos"];
      
        if(![[NSFileManager defaultManager] fileExistsAtPath:_path]){
            [[NSFileManager defaultManager]  createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
    return _path;
}


-(void) saveImage:(UIImage *) image name:(NSString *)name{
     NSString * imagePath = [self.storePath stringByAppendingPathComponent:name];
      imagePath = [imagePath stringByAppendingPathExtension:@"jpg"];
    NSData * data = UIImageJPEGRepresentation(image, 1);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath]) {
        [fileManager removeItemAtPath:imagePath error:nil];
    }
    [fileManager createFileAtPath:imagePath contents:data attributes:nil];
}
@end
