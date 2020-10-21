//
//  VideoService.h
//  YouJia
//
//  Created by aa on 14-4-18.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoService : NSObject

/*用mp4编码格式进行编码
 *@param  url    原视频存放url
 *@param  encodeUrl   编码后的视频存放路径
 *@return
 */
+ (void)encodeMP4WithVideoUrl:(NSURL *)url
               outputVideoUrl:(NSString *)encodeUrl
                 blockHandler:(void (^)(AVAssetExportSession*))handler;

/*视频压缩并转码成mp4
 *@param   inputURL  需要压缩的视频地址
 *@param   outputURL   压缩后的视频存放地址
 *@param    handler   block模块
 */
+ (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler;

/*视频合成
 *@param  firstUrl   第一段视频的url
 *@param   secondUrl   第二段视频的url
 *@param   outputUrl   合成后视频存放的url
 *@param   size       视频size
 *
 */
+ (void)mergeVideoFromFristVideoUrl:(NSURL *)firstUrl
                     secondVideoUrl:(NSURL *)secondUrl
                 withOutputVideoUrl:(NSURL *)outputUrl
                       andVideoSize:(CGSize)size
                       blockHandler:(void (^)(AVAssetExportSession*))handler;

/*视频添加水印
 *@param  videoUrl   视频的url
 *@param   img        水印图片
 *@param   outputPath   处理后视频存放的路径
 *@param   size       视频size
 *@param   imgRect    水印图片在视频中的位置
 *
 */
+ (void) loadVideoByUrl:(NSURL *)videoUrl
           andOutputUrl:(NSString *)outputPath
               andImage:(UIImage *)img
           andVideoSize:(CGSize)size
             andImgRect:(CGRect)imgRect
           blockHandler:(void (^)(AVAssetExportSession*))handler;


#pragma mark-------------------------------

/*获取视频时间长度
 *@param  URL    视频存放的url
 *@return  float类型
 */
+ (CGFloat) getVideoDuration:(NSURL*) URL;

/*获取视频文件的大小
 *@param   path   视频存放的路径
 *@return   单位为kb的数值
 */
+ (NSInteger) getFileSize:(NSString*) path;

/*获取视频缩略图
 *@param   videoURL   视频存放的路径
 *@return   image
 */
+(UIImage *)getImage:(NSURL *)videoURL;

//获取某一帧的图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end
