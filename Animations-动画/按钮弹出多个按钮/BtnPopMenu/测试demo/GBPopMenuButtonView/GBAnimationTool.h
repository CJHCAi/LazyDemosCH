//
//  AnimationTool.h
//  WKMuneController
//
//  Created by macairwkcao on 16/1/25.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>






@interface GBAnimationTool : NSObject
/**
 *  按照圆弧曲线平移
 *
 *  @param duration   动画时长
 *  @param fromPoint  起始点
 *  @param startAngle 开始旋转角度
 *  @param endAngle   结束角度
 *  @param center     圆心
 *  @param radius     半径
 *  @param delegate 代理
 *  @param clockwise  顺时针（NO）逆时针（YES）
 *
 */
+(CAKeyframeAnimation *)moveAccWithDuration:(CFTimeInterval)duration
                                  fromPoint:(CGPoint)fromPoint
                                 startAngle:(CGFloat)startAngle
                                   endAngle:(CGFloat)endAngle
                                     center:(CGPoint)center
                                     radius:(CGFloat)radius
                                   delegate:(id)delegate
                                  clockwise:(BOOL)clockwise;

/**
 *  缩放动画
 *
 *  @param duration   动画时长
 *  @param frameValue 初始值
 *  @param toValue    结束值
 */
+(CABasicAnimation *)scaleAnimationWithDuration:(CFTimeInterval)duration
                                     frameValue:(CGFloat)frameValue toValue:(CGFloat)toValue;


/**
 *  动画组
 *
 *  @param animations 动画数组
 *  @param duration   动画时长
 *
 *  @return CAAnimationGroup
 */
+(CAAnimationGroup *)groupAnimationWithAnimations:(NSArray *)animations
                                         duration:(CGFloat)duration;

+(CABasicAnimation *)opacityAnimationWithDuration:(CFTimeInterval)duration
                                       frameValue:(CGFloat)frameValue
                                          toValue:(CGFloat)toValue;

+(CAKeyframeAnimation *)moveLineWithDuration:(CFTimeInterval)duration
                                   fromPoint:(CGPoint)fromPoint
                                     toPoint:(CGPoint)toPoint
                                    delegate:(id)delegate;

@end
