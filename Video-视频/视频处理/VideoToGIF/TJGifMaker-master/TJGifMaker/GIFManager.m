//
//  GIFManager.m
//  TJGifMaker
//
//  Created by TanJian on 17/6/14.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "GIFManager.h"
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GIFManager ()

@property (nonatomic , strong) NSURL *fileUrl;

@end
@implementation GIFManager

+(instancetype)shareInstance{
    
    static GIFManager *manager;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        manager = [GIFManager new];
    });
    return manager;
    
}

/**
 合成的gif资源路径
 
 @return nsurl
 */
-(NSURL *)gifPathURL{
    
    //创建gif路径
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-HH-mm-ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *appendPath = [NSString stringWithFormat:@"myImageGif%@.gif",dateStr];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:appendPath];

    if([[NSFileManager defaultManager] fileExistsAtPath:self.fileUrl.path]){
        [[NSFileManager defaultManager] removeItemAtPath:self.fileUrl.path error:nil];
    }
    self.fileUrl = fileURL;
    return fileURL;
}

- (NSURL *)currentUrl{
    return self.fileUrl;
}

/**
 合成gif方法一
 
 @param imagePathArray 图片路径数组
 */
- (void)composeGIF:(NSArray *)imagePathArray playTime:(CGFloat)duration complete:(completeHandle)completeHandle{
    
    //创建gif路
    NSURL * gifPath = [self gifPathURL];

    //图像目标
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)gifPath, kUTTypeGIF, imagePathArray.count, NULL);
    
    //gif设置
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary:
                                         @{(__bridge id)kCGImagePropertyGIFLoopCount: @0},
                                     (NSString*)kCGImagePropertyGIFHasGlobalColorMap:[NSNumber numberWithBool:YES],
                                     (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB,
                                     (NSString*)kCGImagePropertyDepth:[NSNumber numberWithInt:8]};
    //a float (not double!) in seconds, rounded to centiseconds in the GIF data
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary:
                                          @{(__bridge id)kCGImagePropertyGIFDelayTime: [NSNumber numberWithFloat:duration]}};
    
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    //合成gif
    for (UIImage *image in imagePathArray)
    {

        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)frameProperties);
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    
    CFRelease(destination);
    
    if (completeHandle) {
        completeHandle();
    }
    
}


/**
 合成gif方法二

 @param imageArr 用于合成gif的数组
 @param duration 两张图片间的图片间距
 @return 合成后的gif图片
 */
- (UIImage *)animatedGIFWithImages:(NSArray *)imageArr marginDuration:(CGFloat)duration  complete:(completeHandle)completeHandle{
    
    if (!imageArr) {
        return nil;
    }

    UIImage *animatedImage;
    CGFloat totalTime;
    if (!duration) {
        
        totalTime = (3.0f / 10.0f) * imageArr.count;
    }else{
     
        duration = duration * imageArr.count;
    }
    
    animatedImage = [UIImage animatedImageWithImages:imageArr duration:duration];
    if (completeHandle) {
        completeHandle();
    }

    return animatedImage;
}


/**
 分解gif
 
 @param gifPath gif路径
 @return 返回gif所有的图片地址数组
 */

/**
 分解gif
 
 @param gifPath gif路径
 @param outputType 希望得到的数据是图片数组还是路径数组
 @param completeHandle 完成block
 */
- (void)decomposeGIF:(NSString *)gifPath outputType:(GIF_OUTPUT_TYPE)outputType complete:(completeWithObjectsHandle)completeHandle{
    
    //图片保存路径
    NSString *imagepPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //用于保存所有图片
    NSMutableArray *imgObjects = [NSMutableArray array];
    
    //1.gif转换成data
    NSData *gifData=[NSData dataWithContentsOfFile:gifPath];
    
    //2.通过data获取image的数据源
    CGImageSourceRef source =CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
    
    //3.获取gif帧数
    size_t count = CGImageSourceGetCount(source);
    
    for (int i=0; i<count; i++) {
        
        //4.获取单帧图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        //5.根据CGImageRef获取图片
        //[UIScreen mainScreen].scale    是计算屏幕分辨率的
        //UIImageOrientationUp           指定新的图像的绘制方向
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        //6.释放CGImageRef对象
        CGImageRelease(imageRef);

        /************************** 保存图片 *************************/
        
        if (outputType == GIF_OUTPUT_TYPE_IMAGE) {
            
            [imgObjects addObject:image];
        }else{
            //图片转data
            NSData *imagedata = UIImagePNGRepresentation(image);
            
            //图片保存路径
            NSString *imgpath = [imagepPath stringByAppendingString:[NSString stringWithFormat:@"/%d.png",i]];
            
            //将图片写入
            [imagedata writeToFile:imgpath atomically:YES];
        
            [imgObjects addObject:imgpath];

        }
        
    }
    //释放source
    CFRelease(source);
    
    if (completeHandle) {
        completeHandle(imgObjects,outputType);
    }
}

/**
 保存gif到相册
 
 @param gifData gif图片data型数据
 */
-(void)saveGIFToAlbumWithData:(NSData *)gifData{

    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = YES;
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:gifData options:options];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                NSLog(@"gif保存成功");
            }

        }];
    }
    else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
        }];
    }
    #else
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self image:nil didFinishSavingWithError:error contextInfo:NULL];
        });
    }];
    #endif

}

/**
 获取想要时间的帧视频图片

 @param outMovieURL 视频路径
 @param time 图片时间点
 @param isKeyImage 是否是取关键帧
 @return 图片
 */
-(UIImage *)getCoverImage:(NSURL *)outMovieURL atTime:(CGFloat)time isKeyImage:(BOOL)isKeyImage{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outMovieURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    __block CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    
    
    //tips:下面7行代码控制取图的时间点是否为关键帧，系统为了性能是默认取关键帧图片的
    CMTime myTime = CMTimeMake(time, 1);
    if (!isKeyImage) {
        assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
//        CMTime duration = asset.duration;
        myTime = CMTimeMake(time*30,30);
    }
    
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:myTime actualTime:NULL error:nil];
    
    if (!thumbnailImageRef){
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    
    return thumbnailImage;
    
}


/**
 将图片按比例缩小

 @param image 原图片
 @param scaleSize 缩放比例
 @return 缩放后图片
 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}


/**
 将图片缩放到指定大小

 @param image 原图片
 @param reSize 指定大小
 @return 指定大小的新图
 */
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}


@end
