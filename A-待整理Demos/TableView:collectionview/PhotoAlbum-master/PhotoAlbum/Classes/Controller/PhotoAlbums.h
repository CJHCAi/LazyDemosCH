//
//  PhotoAlbums.h
//  Tripinsiders
//
//  Created by ZhouQian on 16/7/28.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Typedefs.h"

@protocol PhotoAlbumsDelegate <NSObject>

@optional
//返回自定义的超过最大可选张数的提示信息
- (NSString*)photoAlbumsExceedMaxImageCountMessage:(NSInteger)maxImageCount;

@end


@interface PhotoAlbums : NSObject
/**
 *  designated initializer，更多参数可配
 *
 *  @param maxImagesCount 最大张数
 *  @param type           相册类型
 *  @param bSingleSelect  是否单选
 *  @param bEnableCrop    是否剪裁
 *  @param delegate       <#delegate description#>
 *  @param finishBlock    图片选择回调
 */
+ (void)photoWithMaxImagesCount:(NSInteger)maxImagesCount type:(ZQAlbumType)type bSingleSelect:(BOOL)bSingleSelect crop:(BOOL)bEnableCrop delegate:(id)delegate didFinishPhotoBlock:(void (^)(NSArray<UIImage*> *photos))finishBlock;


/**
 *  单选照片
 *
 *  @param crop        是否支持剪裁
 *  @param delegate    <#delegate description#>
 *  @param finishBlock 选择后返回UIImage数组，只有一个UIImage
 */
+ (void)photoSingleSelectWithCrop:(BOOL)crop delegate:(id)delegate didFinishPhotoBlock:(void (^)(NSArray<UIImage*> *photos))finishBlock;


/**
 *  多选照片
 *
 *  @param maxImagesCount 最多可选的张数
 *  @param delegate       <#delegate description#>
 *  @param finishBlock    选择后返回UIImage数组
 */
+ (void)photoMultiSelectWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id)delegate didFinishPhotoBlock:(void (^)(NSArray<UIImage*> *photos))finishBlock;



/**
 *  单选视频（视频默认单选）
 *
 *  @param duration                    最大支持的视频时长
 *  @param delegate                    <#delegate description#>
 *  @param uiUpdateBlock               选择视频后关掉相册前更新需要显示的界面
 *  @param didFinishPickingVideoHandle 返回视频的本地地址，封面（第一帧），和视频资源
 */
+ (void)photoVideoWithMaxDurtion:(NSTimeInterval)duration
                        Delegate:(id)delegate
      updateUIFinishPickingBlock:(void (^)(UIImage *cover))uiUpdateBlock
     didFinishPickingVideoHandle:(void (^ )(NSURL *url, UIImage *cover, id avAsset))didFinishPickingVideoHandle;
@end
