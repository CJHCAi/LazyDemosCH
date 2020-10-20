//
//  AnimationTool.m
//  WKMuneController
//
//  Created by macairwkcao on 16/1/25.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import "GBAnimationTool.h"
#import <UIKit/UIKit.h>

@implementation GBAnimationTool

#pragma mark 平移动画
/**
 *  按照圆弧曲线平移
 *
 *  @param duration   动画时长
 *  @param fromPoint  起始点
 *  @param startAngle 开始旋转角度
 *  @param endAngle   结束角度
 *  @param center     圆心
 *  @param radius     半径
 *  @param delegate
 *  @param clockwise  顺时针（NO）逆时针（YES）
 *
 *  @return 
 */
+(CAKeyframeAnimation *)moveAccWithDuration:(CFTimeInterval)duration
                                  fromPoint:(CGPoint)fromPoint
                                 startAngle:(CGFloat)startAngle
                                   endAngle:(CGFloat)endAngle
                                     center:(CGPoint)center
                                     radius:(CGFloat)radius
                                   delegate:(id)delegate
                                  clockwise:(BOOL)clockwise{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.duration = duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
    CGPathAddArc(path, nil, center.x, center.y, radius, startAngle, endAngle, clockwise);
    keyFrameAnimation.path = path;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.delegate  = delegate;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    CGPathRelease(path);
    return keyFrameAnimation;
}

+(CAKeyframeAnimation *)moveLineWithDuration:(CFTimeInterval)duration
                                   fromPoint:(CGPoint)fromPoint
                                     toPoint:(CGPoint)toPoint
                                    delegate:(id)delegate{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.duration = duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
    CGPathAddLineToPoint(path, nil, toPoint.x, toPoint.y);
    keyFrameAnimation.path = path;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.delegate  = delegate;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    CGPathRelease(path);
    return keyFrameAnimation;
}

#pragma mark - 缩放动画
+(CABasicAnimation *)scaleAnimationWithDuration:(CFTimeInterval)duration frameValue:(CGFloat)frameValue toValue:(CGFloat)toValue{
    //1.实例化基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //2.设置动画属性
    //fromValue & toValue
    [anim setFromValue:@(frameValue)];
    //从当前大小缩小到一半，然后恢复初始大小
    [anim setToValue:@(toValue)];
    
    //自动翻转动画
        [anim setAutoreverses:NO];
    //动画时长
    [anim setDuration:duration];
    
    //3.将动画添加到图层
    //    [self.myView.layer addAnimation:anim forKey:nil];
    return anim;
}

/**
 *  动画组
 *
 *  @param animations 动画数组
 *  @param duration   动画时长
 *
 *  @return CAAnimationGroup
 */
+(CAAnimationGroup *)groupAnimationWithAnimations:(NSArray *)animations duration:(CGFloat)duration{
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.animations = animations;
    animationGroup.duration = duration;
//    animationGroup.fillMode = kCAFillModeForwards;
//    animationGroup.removedOnCompletion = NO;
    return animationGroup;

}

#pragma mark - 透明度
+(CABasicAnimation *)opacityAnimationWithDuration:(CFTimeInterval)duration frameValue:(CGFloat)frameValue toValue:(CGFloat)toValue{
    //1.实例化基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    //2.设置动画属性
    //fromValue & toValue
    [anim setFromValue:@(frameValue)];
    //从当前大小缩小到一半，然后恢复初始大小
    [anim setToValue:@(toValue)];
    //自动翻转动画
    //    [anim setAutoreverses:YES];
    //动画时长
    [anim setDuration:duration];
    
    //3.将动画添加到图层
    //    [self.myView.layer addAnimation:anim forKey:nil];
    return anim;
}

@end
