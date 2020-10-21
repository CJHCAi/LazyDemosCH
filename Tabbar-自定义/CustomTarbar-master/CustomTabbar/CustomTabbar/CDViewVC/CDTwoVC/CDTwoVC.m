//
//  CDTwoVC.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDTwoVC.h"
@interface CDTwoVC ()<CAAnimationDelegate>
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation CDTwoVC

- (UIButton *)btn{
    if (!_btn){
        _btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(60, 100, 80, 80);
        _btn.layer.cornerRadius = 40;
        _btn.layer.masksToBounds = YES;
        _btn.backgroundColor = [UIColor greenColor];
    }
    return _btn;
}
- (UIView *)circleView
{
    if (!_circleView)
    {
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(250, 100, 80, 80)];
        _circleView.backgroundColor = [UIColor yellowColor];
    }
    return _circleView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.btn];
    [self.view addSubview:self.circleView];
    [self shapeAnimation];
    UIButton *begin  = [UIButton buttonWithType:UIButtonTypeCustom];
    begin.frame = CGRectMake(50, HH-100, 100, 40);
    [begin setTitle:@"开始" forState:UIControlStateNormal];
    [begin addTarget:self action:@selector(beginAnimation) forControlEvents:UIControlEventTouchUpInside];
    begin.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:begin];
    [self.view addSubview:self.btn];
    
}

- (void)beginAnimation
{
    [self AnimationView];
    [self CircleAnimation];
    
}
- (void)shapeAnimation
{
//    _D_HeadImage.layer.cornerRadius = 20.0;
//    _D_HeadImage.layer.masksToBounds = YES;
   
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cd_cycleImage"]];
    image.frame =CGRectMake(50, 200, WW-100, WW-100);
    image.layer.cornerRadius = (WW-100)/2;
    image.layer.masksToBounds = YES;
    image.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [self.view addSubview:image];
    
    
    UIImageView *small = [[UIImageView alloc] initWithFrame:CGRectMake((WW-20)/2, 10, 20, 20)];
    small.image = [UIImage imageNamed:@"nodata"];
    
    [image addSubview:small];
    
    //添加动画
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
    monkeyAnimation.duration = 30.0f;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO;
    monkeyAnimation.repeatCount = FLT_MAX;
    [image.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    //[_cycleImage stopAnimating];
    // 加载动画 但不播放动画
    image.layer.speed = 3.0;
}
// 弹球动画
- (void)AnimationView
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    // 动画路径
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    // 下落上弹的点
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(100, 50)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 280)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 150)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 280)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 230)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 280)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 270)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 280)]
                         ];
    // 上下弹时 的状态可以自己修改效果
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    
    animation.keyTimes = @[@0.0, @0.32, @0.52, @0.73, @0.84, @0.91, @0.96, @1.0];  //时间限制
    _btn.layer.position = CGPointMake(100, 268);
    [_btn.layer addAnimation:animation forKey:nil];
}

- (void)CircleAnimation
{
    if (!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = _circleView.bounds;
    }
    //    shapeLayer.strokeStart = 0.1;
    //    shapeLayer.strokeEnd   = 0.8;
    // 贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_circleView.bounds];
    _shapeLayer.path = path.CGPath;
    // 填充色
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    // 路径的宽度
    _shapeLayer.lineWidth = 2.0f;
    _shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    // 动画实现的view层
    [_circleView.layer addSublayer:_shapeLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.duration = 3.0f;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 动画从那开始到哪结束
    basicAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    basicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    /*
   （要想fillMode有效，最好设置removedOnCompletion=NO）
   kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢
   复到之前的状态 
   kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态.
   kCAFillModeBackwards 在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.
   你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了  
   layer,layer便处于动画初始状态
   kCAFillModeBoth 这个其实就是上面两个的合成.动画加入后在开始之前,layer便处于动画初始状态,动画结束后layer保持
   动画最后的状
    **/
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    [_shapeLayer addAnimation:basicAnimation forKey:@"strokeEndAnimation"];
}

@end
