//
//  UIButton+SD.h
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "UIImage+ReMake.h"



@interface UIButton (SD)

/**
 *  头像
 *
 *  @param urlStr  图片地址
 *  @param phImage 性别b
 */
-(void)headImageWithUrlStr:(NSString *)urlStr genInt:(int)gen;
-(void)headImageWithUrlStrBtnImage:(NSString *)urlStr genInt:(int)gen;
/**
 *  普通网络图片展示
 *
 *  @param urlStr  图片地址
 *  @param phImage 占位图片
 */
-(void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage;

- (void)LH_imageWithURL:(NSString *)url placeHolder:(UIImage *)image;
-(void)headImageWithUrlStrBack:(NSString *)urlStr genInt:(int)gen;
/**
 *  带有进度的网络图片展示
 *
 *  @param urlStr         图片地址
 *  @param phImage        占位图片
 *  @param completedBlock 完成
 */
-(void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage state:(UIControlState)state completedBlock:(SDWebImageCompletionBlock)completedBlock;



@end
