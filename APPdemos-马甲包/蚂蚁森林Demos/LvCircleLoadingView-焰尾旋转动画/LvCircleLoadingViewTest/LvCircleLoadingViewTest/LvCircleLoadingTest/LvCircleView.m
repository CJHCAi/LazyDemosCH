//
//  LvCircleLoadingView.m
//  LvCircleLoadingViewTest
//
//  Created by lv on 2016/11/10.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "LvCircleView.h"
#import "UIColor+Lv.h"
@interface LvCircleView ()
{
    CAShapeLayer *_shapeLayer;
    UIView *_animationView;
}

@end

@implementation LvCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];

        _animationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_animationView];
        
        self.imgLogo=[[UIImageView alloc]init];
        [self addSubview:self.imgLogo];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CALayer *gradientLayer = [CALayer layer];

    
    
    UIColor *colorStart=self.colorStart;//[[UIColor whiteColor]colorWithAlphaComponent:1];//[UIColor colorWithHexString:@"4F94CD"];
    UIColor *colorEnd=self.colorEnd;//[[UIColor whiteColor]colorWithAlphaComponent:0.5];//[UIColor colorWithHexString:@"BFEFFF"];

//    
    _shapeLayer = [CAShapeLayer layer]; //创建一个track shape layer
    _shapeLayer.frame = self.bounds;
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _shapeLayer.strokeColor = [[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _shapeLayer.opacity = 1; //背景颜色的透明度
    _shapeLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _shapeLayer.lineWidth =  self.lineWidth;//线的宽度
    
    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);    // 分段设置渐变色
//    leftLayer.locations = @[@0.4, @0.65];
    leftLayer.colors = @[ (id)colorStart.CGColor,(id)colorEnd.CGColor];
   
    [gradientLayer addSublayer:leftLayer];
    
    //右侧渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height/2, self.bounds.size.width / 2, self.bounds.size.height/2);
//    rightLayer.locations = @[@0.65,@0.8];
    rightLayer.colors = @[(id)[[UIColor whiteColor]colorWithAlphaComponent:0.01].CGColor, (id)colorEnd.CGColor];
    [gradientLayer addSublayer:rightLayer];
    
    
    
    [[UIColor orangeColor] set];
    
    CGPoint pointCenter=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius=self.frame.size.width/2-_shapeLayer.lineWidth;
    UIBezierPath *bezier=[UIBezierPath bezierPath];
    [bezier addArcWithCenter:pointCenter radius:radius startAngle:M_PI*2 endAngle:M_PI*3/2-0.1 clockwise:YES];
//    [bezier stroke];
    _shapeLayer.path =[bezier CGPath];
    
    [gradientLayer setMask:_shapeLayer]; //用progressLayer来截取渐变层
    [_animationView.layer addSublayer:gradientLayer];
    
    
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform.rotation"] ;
    basic.duration=1;
    basic.repeatCount=99999999;
    basic.fromValue=@(0);
    basic.toValue=@(M_PI*2);
    [_animationView.layer addAnimation:basic forKey:nil];
    
    self.imgLogo.bounds=CGRectMake(0, 0, self.frame.size.width-self.lineSpacing-2*self.lineWidth, self.frame.size.width-self.lineSpacing-2*self.lineWidth);
    self.imgLogo.layer.cornerRadius=self.imgLogo.bounds.size.width/2;
    self.imgLogo.clipsToBounds=YES;
    self.imgLogo.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
}

-(void)setImageLogo:(UIImage *)imageLogo
{
    _imageLogo=imageLogo;
    self.imgLogo.image=imageLogo;
}

@end
