//
//  UIViewController+JWTCJZCViewController.m
//  xingtu
//
//  Created by Wondergirl on 2016/12/12.
//  Copyright © 2016年 🌹Wondgirl😄. All rights reserved.
//

#import "JWTCJZCViewController.h"
#import "AppDelegate.h"
#import "JWTHomeViewController.h"
@implementation JWTCJZCViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = @"兴途";
    // self.navigationController.title = @"兴途";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     * 抽屉按钮
     */
    UIBarButtonItem * leftSliderBar = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"topbar_menu_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftSliderClick)];
    self.navigationItem.leftBarButtonItem = leftSliderBar;
    
    [self createHeadView];
    
}

#pragma mark- 点击打开抽屉
/**
 *  点击打开抽屉
 */
-(void)leftSliderClick
{
    // 通过app 回到主Window用来显示抽屉的VC
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // 由关闭状态打开抽屉
    if (appDelegate.leftSlideVC.closed)
    {
        [appDelegate.leftSlideVC openLeftView];
    }
    //关闭抽屉
    else
    {
        [appDelegate.leftSlideVC closeLeftView];
    }
}

#pragma mark - 配置视图

//配置视图
-(void)createHeadView{
    // 头部两个命令按钮
    UIButton *buttonbus = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, ScreenW/2+10, 50)];
    [buttonbus setBackgroundImage:[UIImage imageNamed:@"HomeIndex_busBG_nor"] forState:UIControlStateNormal];
    [buttonbus setTitle:@"  汽车票" forState:UIControlStateNormal];
    [buttonbus setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [buttonbus setImage:[UIImage imageNamed:@"HomeIndex_busLogo_nor"] forState:UIControlStateNormal];
    [buttonbus addTarget:self action:@selector(checkHomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonbus];
    
    UIButton *buttonCJZC = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW/2-10, 60, ScreenW/2-10, 50)];
    [buttonCJZC setTitle:@"  火车票" forState:UIControlStateNormal];
    [buttonCJZC setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    [buttonCJZC setImage:[UIImage imageNamed:@"HomeIndex_trainLogo_HL"] forState:UIControlStateNormal];
    [buttonCJZC setUserInteractionEnabled:NO];
    [self.view addSubview:buttonCJZC];
}
//跳转到查询结果页面
-(void)checkHomeBtnClick{
    NSLog(@"HOME");
    JWTHomeViewController *HomeVC = [[JWTHomeViewController alloc] init];
    [self.navigationController pushViewController:HomeVC animated:NO];
    
}
@end
