//
//  ViewController.m
//  TouchBut
//
//  Created by 邱荣贵 on 2017/12/6.
//  Copyright © 2017年 邱久. All rights reserved.
//

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define  tabBarViewW 200

#import "TouchButton.h"

#import "ViewController.h"

@interface ViewController ()
{
    BOOL flag; //控制tabbar的显示与隐藏标志
    TouchButton *myButton;
    UIView *tabBarView;
}


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor greenColor];

    [self addCustomElements];
    
}
//做了修改 设置tab bar
- (void)addCustomElements
{
    myButton = [TouchButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 100, 40, 40);
    myButton.MoveEnable = YES;
    //TabBar上按键图标设置
    [myButton setTag:10];
    flag = NO;//控制tabbar的显示与隐藏标志 NO为隐藏
    [myButton setBackgroundImage:[UIImage imageNamed:@"touch"] forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(tabbarbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
    
    [self _initTabBar];
}

//初始化tabbar
-(void)_initTabBar
{
    //tab bar view  始终居中显示
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2 - tabBarViewW/2, HEIGHT/2 - tabBarViewW/2, tabBarViewW , tabBarViewW)] ;
    tabBarView.layer.masksToBounds = YES;
    tabBarView.layer.cornerRadius = 10;//设置圆角的大小
    tabBarView.backgroundColor = [UIColor blackColor];
    tabBarView.alpha = 0.8f;//设置透明
    [self.view addSubview:tabBarView];
    
    //循环设置tabbar上的button
    NSArray *tabTitle = @[@"download",@"block",@"bluetooth",@"file"];
    
    for (int i=0; i<tabTitle.count; i++) {
        CGRect rect;
        rect.size.width = 60;
        rect.size.height = 60;
        switch (i) {
            case 0:
                rect.origin.x = 100-30;
                rect.origin.y = 40-30;
                break;
            case 1:
                rect.origin.x = 160-30;
                rect.origin.y = 100-30;
                break;
            case 2:
                rect.origin.x = 100-30;
                rect.origin.y = 160-30;
                break;
            case 3:
                rect.origin.x = 40-30;
                rect.origin.y = 100-30;
                break;
        }
        
        //设置每个tabView
        UIView *tabView = [[UIView alloc] initWithFrame:rect];
        [tabBarView addSubview:tabView];
        
        //设置tabView的图标
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.frame = CGRectMake(15, 0, 30, 30);
        [tabButton setBackgroundImage:[UIImage imageNamed:tabTitle[i]] forState:UIControlStateNormal];
        [tabButton setTag:i];
        [tabButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabView addSubview:tabButton];
        
        //设置标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 60, 15)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = tabTitle[i];
        [tabView addSubview:titleLabel];
    }
    
    [tabBarView setHidden:YES];
}



//显示 隐藏 tabbar
- (void)tabbarbtn:(TouchButton *)btn
{
    //在移动的时候不触发点击事件
    if (!btn.MoveEnabled) {
        
        if(!flag){
            tabBarView.hidden = NO;
            flag = YES;
        }else{
            tabBarView.hidden = YES;
            flag = NO;
        }
    }
    
}

- (void)buttonClicked:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
}


@end
