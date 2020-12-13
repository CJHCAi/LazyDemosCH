//
//  ViewController.m
//  RainDemo
//
//  Created by 梁新昌 on 2019/6/24.
//  Copyright © 2019 Tainfn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CAEmitterLayer *rainLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 下雨☔️
    [self rainAction];
}

- (void)rainAction {
    
//    1.设置 CAEmitterLayer
    CAEmitterLayer *rainLayer = [CAEmitterLayer layer];
//    2.在背景图上添加粒子图层
    [self.view.layer addSublayer:rainLayer];
    
    self.rainLayer = rainLayer;
    
//    3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    rainLayer.emitterSize = self.view.frame.size;
    rainLayer.emitterPosition = CGPointMake(self.view.frame.size.width * 0.5, -10);
//    4.配置 cell
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"caomei"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 1;
    snowCell.scaleRange = 0.f;
    
    CAEmitterCell *kaixinguoCell = [CAEmitterCell emitterCell];
    kaixinguoCell.contents = (id)[[UIImage imageNamed:@"kaixinguo"] CGImage];
    kaixinguoCell.birthRate = 1.0;
    kaixinguoCell.lifetime = 30;
    kaixinguoCell.speed = 2;
    kaixinguoCell.velocity = 10.f;
    kaixinguoCell.velocityRange = 10.f;
    kaixinguoCell.yAcceleration = 60;
    kaixinguoCell.scale = 1;
    kaixinguoCell.scaleRange = 0.f;
    
    CAEmitterCell *niuyouguoCell = [CAEmitterCell emitterCell];
    niuyouguoCell.contents = (id)[[UIImage imageNamed:@"niuyouguo"] CGImage];
    niuyouguoCell.birthRate = 1.0;
    niuyouguoCell.lifetime = 30;
    niuyouguoCell.speed = 2;
    niuyouguoCell.velocity = 10.f;
    niuyouguoCell.velocityRange = 10.f;
    niuyouguoCell.yAcceleration = 60;
    niuyouguoCell.scale = 1;
    niuyouguoCell.scaleRange = 0.f;
    
    rainLayer.emitterCells = @[snowCell, kaixinguoCell, niuyouguoCell];
}


@end
