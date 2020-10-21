//
//  CPJClippingPanel.h
//  IOSTestFramework
//
//  Created by shuaizhai on 11/27/15.
//  Copyright © 2015 com.shuaizhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPJClippingCircle;
@class CPJGridLayar;

@protocol CPJClippingPanelProtocol <NSObject>

@required

- (void)show;

/**
 * 更换图片或者更换设定clippingRect的时候需要被调用
 * 确保clippingRect始终在图片内部.
 */
- (void)initializeImageViewSize;

/**
 * 处理图片移出裁剪框的情况
 */
- (CGPoint)handleBorderOverflow;

/**
 * 处理图片放缩小于裁剪框的尺寸
 */
- (CGRect)handleScaleOverflowWithPoint:(CGPoint)point;

@end


/**
 * 存放需要裁剪的图片、遮罩层
 */
@interface CPJClippingPanel : UIView <CPJClippingPanelProtocol>

@property (nonatomic, strong)CPJGridLayar *gridLayer;
@property (nonatomic, strong)UIImageView  *imageView;

@end

/**
 * 遮罩层：覆盖在需要裁剪的图片上面的层，其中间透明的部分为裁剪剩余部分。
 */
@interface CPJGridLayar : CALayer

@property (nonatomic, assign) CGRect    clippingRect;
@property (nonatomic, strong) UIColor   *bgColor;
@property (nonatomic, strong) UIColor   *gridColor;

@end

/**
 * 用来调节遮罩层中间透明大小的按钮
 */
@interface CPJClippingCircle : UIView

@end