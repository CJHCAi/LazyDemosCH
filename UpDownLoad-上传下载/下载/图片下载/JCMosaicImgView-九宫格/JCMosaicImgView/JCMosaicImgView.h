//
//  JCMosaicImgView.h
//  JCMosaicImgViewDemo
//
//  Created by jimple on 14-1-9.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemoteImgListOperator;
@interface JCMosaicImgView : UIView

// 仅针对九宫格图片，最多九个图片

// 根据图片数量获取视图大小
+ (CGFloat)imgHeightByImg:(NSArray *)arrImg;
+ (CGFloat)imgWidthByImg:(NSArray *)arrImg;

// 使用 JCRemoteImgListOperator 进行图片下载
// https://github.com/jimple/RemoteImgListOperator
- (void)setImgListOper:(RemoteImgListOperator *)objOper;

// 在TableViewCell里，重用时清空内容
- (void)prepareForReuse;

// 输入图片URL
- (void)showWithImgURLs:(NSArray *)arrImgURLs;

- (NSArray *)allImgViews;
- (NSArray *)allImgURLs;



@end
