//
//  ViewController.m
//  CoreAnimation
//
//  Created by 七啸网络 on 2017/7/10.
//  Copyright © 2017年 youbei. All rights reserved.
//
#define  angleRadion(angle) (angle/180.0*M_PI)
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self xinTiaoAnimation];
//    [self shakeAnimation];
}

/**
 抖动动画  路径动画
 */
-(void)shakeAnimation{

    //核心动画
    CAKeyframeAnimation * anim=[CAKeyframeAnimation animation];
    anim.keyPath=@"transform.rotation";
    anim.repeatCount=MAXFLOAT;
    anim.values=@[@(angleRadion(-5)),@(angleRadion(5)),@(angleRadion(-5))];
    //    anim.path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(30, 30, 100, 200)].CGPath;anim.duration=3;
    
    [_imageVa.layer addAnimation:anim forKey:nil];
    //锚点---绕的抖动的点
    _imageVa.layer.anchorPoint=CGPointZero;


}


/**
 心跳动画
 */
-(void)xinTiaoAnimation{
    CABasicAnimation * animation=[CABasicAnimation animation];
   animation.keyPath=@"transform.scale";
    animation.toValue=@(0.5);
//    animation.toValue=[NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    animation.repeatCount=MAXFLOAT;
    //动画完成时不要移除动画，取消动画反弹
    animation.removedOnCompletion=NO;
    //设置动画完成时保持最新效果
    animation.fillMode=kCAFillModeForwards;
    [_XinImage.layer addAnimation:animation forKey:nil];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
