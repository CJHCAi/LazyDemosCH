//
//  ViewController.m
//  YJDemo
//
//  Created by zhu on 2017/5/10.
//  Copyright © 2017年 zhu. All rights reserved.
//

#import "ViewController.h"
#import "FiltrateView.h"

@interface ViewController ()
{
    UIView *rightfullView;//筛选全屏大背景
    FiltrateView *filtrateView;//筛选view

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *lable=[[UILabel alloc]initWithFrame:self.view.frame];
    lable.text = @"点击屏幕";
    lable.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:lable];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self rightBtn];
}

-(void)rightBtn{
    rightfullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    rightfullView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:rightfullView];
    filtrateView = [[FiltrateView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT)];
    __weak typeof(rightfullView) weakrightfullView = rightfullView;
    filtrateView.sendBlock = ^(){
        [weakrightfullView removeFromSuperview];
    };
    
    [rightfullView addSubview:filtrateView];
    [UIView animateWithDuration:0.5 animations:^{
        filtrateView.frame = CGRectMake(50, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT);
    }];
    
}
@end
