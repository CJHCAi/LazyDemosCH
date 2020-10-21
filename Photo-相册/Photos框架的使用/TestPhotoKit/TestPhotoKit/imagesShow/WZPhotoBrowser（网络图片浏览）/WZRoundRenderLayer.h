//
//  WZRoundRenderLayer.h
//  WZBaseRoundSelector
//
//  Created by admin on 17/3/28.
//  Copyright © 2017年 WZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol WZRoundRenderLayerDelegate <NSObject>

/**
 *
 *  @param currentPoint : bezier path current point
 */
- (void)renderPathCurrentPoint:(CGPoint)currentPoint;

@end


/**
 *   始终在－PI / 2.0 处绘制   只负责绘制
 */
@interface WZRoundRenderLayer : CALayer

/**
 *  设置进行绘制弧
 */
@property (nonatomic, assign) float renderAngle;//范围 0 ~ M_PI * 2.0

@property (nonatomic, weak) id<WZRoundRenderLayerDelegate> renderLayerDelegate;

- (instancetype)initWithCircleRadius:(CGFloat)circleRadius layerLineWidth:(CGFloat)layerLineWidth;

/**
 *  渲染表层的颜色
 */
- (void)setSurfaceTrackColor:(UIColor *)color;

/**
 *  渲染底层的颜色
 */
- (void)setBottomTrackColor:(UIColor *)color;

@end
