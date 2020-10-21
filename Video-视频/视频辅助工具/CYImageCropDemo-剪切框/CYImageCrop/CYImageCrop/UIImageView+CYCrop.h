//
//  UIImageView+CYCrop.h
//  CYImageCrop
//
//  Created by Cyrus on 16/6/10.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYCropView.h"

@interface UIImageView (CYCrop)

/** 裁剪视图 */
@property (nonatomic, strong, readonly)CYCropView *cy_cropView;

/** 根据缩放类型显示裁剪视图 */
- (void)cy_showCropViewWithType:(CYCropScaleType)type;

/** 隐藏裁剪视图 */
- (void)cy_hideCropView;

/** 计算出 imageView 中显示内容的尺寸 */
- (CGRect)cy_contentFrame;

/** 返回实际裁剪区域的 frame  */
@property (nonatomic, assign, readonly)CGRect cy_cropFrame;
/** 返回实际裁剪区域占据整个视图的位置比例（0，0，0，0）是左上角 （1，1，1，1）是右下角*/
@property (nonatomic, assign, readonly)CGRect cy_cropFrameRatio;


/** 设置缩放类型 */
- (void)cy_setScaleType:(CYCropScaleType)scaleType;

/** 设置每次拖拽裁剪框后的回调 */
- (void)cy_setComplectionHandler:(void (^)())complectionHandler;


@end

