//
//  ViewController.m
//  CABasic
//
//  Created by zhangwei on 17/4/27.
//  Copyright © 2017年 jyall. All rights reserved.
//

#import "ViewController.h"

#import "EmitterBtn.h"

@interface ViewController ()

@property (nonatomic , strong) CABasicAnimation * anim;
@property (nonatomic , strong) CAReplicatorLayer *musicLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    
       [self musicReplicatorLayer];
   
       [self ThumbupLayer];
    
   
}
- (void)musicReplicatorLayer
{
    _musicLayer = [CAReplicatorLayer layer];
    _musicLayer.frame = CGRectMake(0, 0, 60, 50);
    _musicLayer.position = self.view.center;
    //设置复制层里面包含的子层个数
    _musicLayer.instanceCount = 4;
    //设置下个子层相对于前一个的偏移量
    _musicLayer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0);     //每个layer的间距。
    //设置下一个层相对于前一个的延迟时间
    _musicLayer.instanceDelay = 0.2;
    _musicLayer.backgroundColor = [UIColor redColor].CGColor;
    _musicLayer.masksToBounds = YES;
    [self.view.layer addSublayer:_musicLayer];
    
    CALayer *tLayer = [CALayer layer];
    tLayer.frame = CGRectMake(10, 20, 5, 40);
    tLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [_musicLayer addSublayer:tLayer];
    
    CABasicAnimation *musicAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    musicAnimation.duration = 0.35;
    musicAnimation.fromValue = @(tLayer.frame.size.height);
//    musicAnimation.toValue = @(tLayer.frame.size.height - 10);
    musicAnimation.byValue = @(20);
    musicAnimation.autoreverses = YES;
    musicAnimation.repeatCount = MAXFLOAT;
    
    [tLayer addAnimation:musicAnimation forKey:@"musicAnimation"];
}


- (void)ThumbupLayer{
    
    EmitterBtn *thumup = [EmitterBtn buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:thumup];
    [thumup setImage:[UIImage imageNamed:@"praise_default"] forState:UIControlStateNormal];
    [thumup setImage:[UIImage imageNamed:@"praise_select"]  forState:UIControlStateSelected];
    thumup.frame = CGRectMake(100, 100, 30, 30);
    [thumup addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)Click:(UIButton *)btn{
    btn.selected = !btn.selected;
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
