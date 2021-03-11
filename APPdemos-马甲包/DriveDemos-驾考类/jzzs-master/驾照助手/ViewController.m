//
//  ViewController.m
//  驾照助手
//
//  Created by 淡定独行 on 16/5/4.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import "ViewController.h"

#define kScreenX [UIScreen   mainScreen].bounds.size.width            //屏幕宽度
#define kScreenY [UIScreen   mainScreen].bounds.size.height           //屏幕高度


@interface ViewController ()
{
    UIView *carsView;
    UIButton *automobileBtn; //汽车
    UIButton *truckBtn; //货车
    UIButton *passengerBtn; //客车
    UIButton *motorcycleBtn; //摩托车
    UIButton *cancelBtn; //取消
}
@property (weak, nonatomic) IBOutlet UIButton *seleCarBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 选择车型
- (IBAction)changeCar:(id)sender {
    
    [self initWithCarView];
    
    [self setCarsInfo];
}

#pragma 初始化视图
-(void)initWithCarView
{
    
    carsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenX, kScreenY)];
    [self.view addSubview:carsView];
    [self carAnimation:@"fromTop"];
    
    
    automobileBtn = [[UIButton alloc]init];
    [automobileBtn addTarget:self action:@selector(didSeleCar:) forControlEvents:UIControlEventTouchUpInside];
    [carsView addSubview:automobileBtn];
    
    
    
    
    truckBtn = [[UIButton alloc]init];
    [truckBtn addTarget:self action:@selector(didSeleCar:) forControlEvents:UIControlEventTouchUpInside];
    [carsView addSubview:truckBtn];
    
    passengerBtn = [[UIButton alloc]init];
    [passengerBtn addTarget:self action:@selector(didSeleCar:) forControlEvents:UIControlEventTouchUpInside];
    [carsView addSubview:passengerBtn];
    
    motorcycleBtn = [[UIButton alloc]init];
    [motorcycleBtn addTarget:self action:@selector(didSeleCar:) forControlEvents:UIControlEventTouchUpInside];
    [carsView addSubview:motorcycleBtn];
    
    cancelBtn = [[UIButton alloc]init];
    [cancelBtn addTarget:self action:@selector(cancelSelectCar) forControlEvents:UIControlEventTouchUpInside];
    [carsView addSubview:cancelBtn];
    
    

}



#pragma 设置button
-(void)setCarsInfo
{
    
    carsView.backgroundColor = [UIColor colorWithRed:0.123 green:0.125 blue:0.124 alpha:0.900];
    
    automobileBtn.frame = CGRectMake(kScreenX/2-kScreenX/5-20, kScreenY/2-20-kScreenX/5, kScreenX/5, kScreenX/5);
    [automobileBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    
    truckBtn.frame = CGRectMake(kScreenX/2+20, kScreenY/2-20-kScreenX/5, kScreenX/5, kScreenX/5);
    [truckBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    
    passengerBtn.frame = CGRectMake(kScreenX/2-kScreenX/5-20, kScreenY/2+20, kScreenX/5, kScreenX/5);
    [passengerBtn setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    
    motorcycleBtn.frame = CGRectMake(kScreenX/2+20, kScreenY/2+20, kScreenX/5, kScreenX/5);
    [motorcycleBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    
    cancelBtn.frame = CGRectMake(kScreenX/2-20, kScreenY-30-40, 40, 40);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"20"] forState:UIControlStateNormal];
    
}




#pragma 选择车型
-(void)didSeleCar : (UIButton *)didSeleBtn
{
    [self.seleCarBtn setBackgroundImage:[didSeleBtn currentBackgroundImage] forState:UIControlStateNormal];
    
    [self cancelSelectCar];
}



#pragma 移除选择车辆carsView 视图
-(void)cancelSelectCar
{
    
    [self carAnimation:@"fromTop"];
    [carsView removeFromSuperview];
    
}

#pragma 动画效果
-(void)carAnimation : (NSString *)animationType;
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    /*
     pageCurl            向上翻一页
     pageUnCurl          向下翻一页
     rippleEffect        滴水效果
     suckEffect          收缩效果，如一块布被抽走
     cube                立方体效果
     oglFlip             上下翻转效果
     */
    animation.type = animationType;
    /*
     kCATransitionFade 淡出
     kCATransitionMoveIn 覆盖原图
     kCATransitionPush 推出
     kCATransitionReveal 底部显出来
     */
    animation.subtype = kCATransitionPush;
    [carsView.superview.layer addAnimation:animation forKey:@"animation"];
  
}






@end
