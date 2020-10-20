//
//  DrawView.m
//  CoreAnimation
//
//  Created by 七啸网络 on 2017/7/10.
//  Copyright © 2017年 youbei. All rights reserved.
//
#import "DrawView.h"
@interface DrawView()
@property(nonatomic,strong)UIBezierPath * path;
@end

@implementation DrawView


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //获取手指触摸点
    UITouch * touch=[touches anyObject];
    CGPoint curP=[touch locationInView:self];
    //创建路径
    UIBezierPath * path=[UIBezierPath bezierPath];
    _path=path;
    //设置起点
    [path moveToPoint:curP];

}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //touch
    UITouch * touch=[touches anyObject];
    
    //获取手指的触摸点
    CGPoint  curP=[touch locationInView:self];
    [_path moveToPoint:curP];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//给imageView添加核心动画
    CAKeyframeAnimation * animation=[CAKeyframeAnimation animation];
    animation.keyPath=@"position";
    animation.path=_path.CGPath;
    animation.duration=2;
    animation.repeatCount=MAXFLOAT
    ;
    [[self.subviews firstObject].layer addAnimation:animation forKey:nil];

}
-(void)drawRect:(CGRect)rect{

    [_path stroke];

}
@end
