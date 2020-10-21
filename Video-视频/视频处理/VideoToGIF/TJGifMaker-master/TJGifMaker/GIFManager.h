//
//  GIFManager.h
//  TJGifMaker
//
//  Created by TanJian on 17/6/14.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 gif分解为图片时输出类型

 - GIF_OUTPUT_TYPE_IMGPATH: 输出图片路径
 - GIF_OUTPUT_TYPE_IMAGE: 输出图片
 */
typedef NS_ENUM(NSUInteger, GIF_OUTPUT_TYPE)
{
    GIF_OUTPUT_TYPE_IMGPATH,
    GIF_OUTPUT_TYPE_IMAGE
};

typedef void (^completeHandle)();
typedef void (^completeWithObjectsHandle)(NSArray *array,GIF_OUTPUT_TYPE type);

@interface GIFManager : NSObject

/**
 单例获取方法

 @return GIFManager单例
 */
+(instancetype)shareInstance;

/**
 合成的gif资源路径

 @return nsurl
 */
- (NSURL *)currentUrl;

/**
 gif图片生成方法一

  @param imagePathArray 用于合成gif的图片数组
  @param duration gif图片的播放时间间隔
 */
- (void)composeGIF:(NSArray *)imagePathArray playTime:(CGFloat)duration complete:(completeHandle)completeHandle;

/**
 合成gif方法二
 
 @param imageArr 用于合成gif的数组
 @param duration 两张图片间的图片间距
 @return 合成后的gif图片
 */
- (UIImage *)animatedGIFWithImages:(NSArray *)imageArr marginDuration:(CGFloat)duration complete:(completeHandle)completeHandle;

/**
 分解gif
 
 @param gifPath gif路径
 @param outputType 希望得到的数据是图片数组还是路径数组
 @param completeHandle 完成block
 */
- (void)decomposeGIF:(NSString *)gifPath outputType:(GIF_OUTPUT_TYPE)outputType complete:(completeWithObjectsHandle)completeHandle;

/**
 保存gif到相册

  @param gifData gif图片data型数据
 */
-(void)saveGIFToAlbumWithData:(NSData *)gifData;


#pragma mark 下面方法使用时应放在UIImage的分类中，这里为了减少文件数量没有做这一步
/**
 获取想要时间的帧视频图片
 
 @param outMovieURL 视频路径
 @param time 图片时间点
 @param isKeyImage 是否是取关键帧
 @return 图片
 */
-(UIImage *)getCoverImage:(NSURL *)outMovieURL atTime:(CGFloat)time isKeyImage:(BOOL)isKeyImage;

/**
 将图片按比例缩小
 
 @param image 原图片
 @param scaleSize 缩放比例
 @return 缩放后图片
 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/**
 将图片缩放到指定大小
 
 @param image 原图片
 @param reSize 指定大小
 @return 缩放后图片
 */
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
