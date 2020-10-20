//
//  EmitterBtn.m
//  CABasic
//
//  Created by zhangwei on 17/4/28.
//  Copyright © 2017年 jyall. All rights reserved.
//

#import "EmitterBtn.h"

@interface EmitterBtn ()
@property (nonatomic , strong) CAEmitterLayer * explosionLayer;

@end

@implementation EmitterBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupExplosion];
    }
    return self;
}



- (void)setupExplosion{
    _explosionLayer = [CAEmitterLayer layer];

    CAEmitterCell *explosionCell = [[CAEmitterCell alloc]init];
    
    explosionCell.name = @"explosion";
    //        设置粒子颜色alpha能改变的范围
    explosionCell.alphaRange = 0.10;
    //        粒子alpha的改变速度
    explosionCell.alphaSpeed = -1.0;
    //        粒子的生命周期
    explosionCell.lifetime = 0.7;
    //        粒子生命周期的范围;
    explosionCell.lifetimeRange = 0.3;
    
    //        粒子发射的初始速度
    explosionCell.birthRate = 2500;
    //        粒子的速度
    explosionCell.velocity = 40.00;
    //        粒子速度范围
    explosionCell.velocityRange = 10.00;
    
    //        粒子的缩放比例
    explosionCell.scale = 0.03;
    //        缩放比例范围
    explosionCell.scaleRange = 0.02;
    
    
    
    
    //        粒子要展现的图片
    explosionCell.contents = (id)([[UIImage imageNamed:@"sparkle"] CGImage]);
    
    _explosionLayer.name = @"explosionLayer";
    
    //        发射源的形状
    _explosionLayer.emitterShape = kCAEmitterLayerCircle;
    //        发射模式
    _explosionLayer.emitterMode = kCAEmitterLayerOutline;
    //        发射源大小
//    _explosionLayer.emitterSize = CGSize.init(width: 10, height: 0);
    _explosionLayer.emitterSize = CGSizeMake(5, 0);

    //        发射源包含的粒子
    _explosionLayer.emitterCells = @[explosionCell];
    //        渲染模式
    _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    _explosionLayer.masksToBounds = false;
    _explosionLayer.birthRate = 0;
   
   

    _explosionLayer.zPosition = 0;
    [self.layer addSublayer:_explosionLayer];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"=====%@",NSStringFromCGRect(self.frame));
     //        发射位置
    _explosionLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)setSelected:(BOOL)selected{
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (selected) {
        animation.values = @[@1.5,@0.8,@1.0,@1.2,@1.0];
        animation.duration = 0.5;
        [self startAnimation];
    }else{
        animation.values = @[@0.8,@1.0];
        animation.duration = 0.4;
    }

    animation.calculationMode = kCAAnimationCubic;
   
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}

- (void)startAnimation{
    _explosionLayer.beginTime = CACurrentMediaTime();
    //每秒生成多少个粒子
    _explosionLayer.birthRate = 1;
//    perform(#selector(STPraiseEmitterBtn.stopAnimation), with: nil, afterDelay: 0.15);
    [self performSelector:@selector(stopAnimation) withObject:self afterDelay:0.15];
}
- (void)stopAnimation{
    _explosionLayer.birthRate = 0;
}

@end
