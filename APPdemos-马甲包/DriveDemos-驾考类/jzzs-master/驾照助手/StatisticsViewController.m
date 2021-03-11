//
//  StatisticsViewController.m
//  驾照助手
//
//  Created by 淡定独行 on 16/5/13.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import "StatisticsViewController.h"
#define kScreenX [UIScreen      mainScreen].bounds.size.width //屏幕宽度
#define kScreenY [UIScreen      mainScreen].bounds.size.height//屏幕高度

@interface StatisticsViewController ()<UIGestureRecognizerDelegate>

@end

@implementation StatisticsViewController
{
    UIView *view;
}
-(id)createStatisticsView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenY, kScreenX, kScreenY-64)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenX, 100)];
    headView.backgroundColor = [UIColor colorWithRed:0.126 green:0.129 blue:0.098 alpha:0.393];
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100,kScreenX, 40)];
    centerView.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[@"答对",@"答错",@"未答"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenX/2-40, 0, 80, 20)];

    
    [centerView addSubview:btn];
    for(int i=0;i<3;i++){
        UILabel *label= [[UILabel alloc]init];
        label.frame = CGRectMake(10*(i+1)+80*(i+1), 20, 40, 40);
        label.text = arr[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        [centerView addSubview:label];
    }
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 100+50, kScreenX, kScreenY-64-100-40)];
    footView.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:headView];
    [view addSubview:centerView];
    [view addSubview:footView];
    
    
    //动画效果
    [UIView animateWithDuration:0.4 animations:^{
        view.frame = CGRectMake(0, 64, kScreenX, kScreenY-64);
        
    }];
    return view;
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}

-(void)hiddenView
{
    NSLog(@"123");
    [UIView animateWithDuration:0.4 animations:^{
        view.frame = CGRectMake(0, kScreenY, kScreenX, kScreenY-64);
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
