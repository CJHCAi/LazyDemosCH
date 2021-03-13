#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface DDYCameraTool : NSObject

/**
 视频转码/压缩
 @param videoURL 原始视频URL路径
 @param presetName 视频质量 建议(默认)AVAssetExportPresetMediumQuality
 @param saveURL 转码压缩后保存URL路径
 @param progress 转码压缩进度
 @param complete 完成回调
 */
+ (void)ddy_CompressVideo:(NSURL *)videoURL
               presetName:(NSString *)presetName
                  saveURL:(NSURL *)saveURL
                 progress:(void (^)(CGFloat progress))progress
                 complete:(void (^)(NSError *error))complete;


/**
 截取视频某个时刻的缩略图
 @param videoURL 视频地址
 @param time 要截取的时刻
 @return 截取到的缩略图
 */
+ (UIImage *)ddy_ThumbnailImageInVideo:(NSURL *)videoURL andTime:(CGFloat)time;

/**
 视频添加背景音乐
 @param videoPath 视频路径
 @param musicPath 背景音乐路径
 @param isKeep 是否保留原来的声音
 @param complete 完成后回调
 */
+ (void)ddy_AddMusicInVideo:(NSURL *)videoPath music:(NSURL *)musicPath keepOrignalSound:(BOOL)isKeep complete:(void (^)(NSURL *savePath))complete;

/**
 视频添加图片水印
 @param videoPath 视频路径
 @param waterImage 水印图片
 @param complete 完成后回调
 */
+ (void)ddy_AddWaterMarkInVideo:(NSURL *)videoPath waterMarkImage:(UIImage *)waterImage complete:(void (^)(NSURL *savePath))complete;

/**
 视频添加文字水印
 @param videoPath 视频路径
 @param waterString 水印文字
 @param complete 完成后回调
 */
+ (void)ddy_AddWaterMarkInVideo:(NSURL *)videoPath waterMarkString:(UIImage *)waterString complete:(void (^)(NSURL *savePath))complete;

@end
/**
 http://www.hudongdong.com/ios/546.html
 */
