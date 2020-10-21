//
//  JWTHomeViewController.m
//  shoppingcentre
//
//  Created by Wondergirl on 16/9/20.
//  Copyright © 2016年 🌹Wondergirl😄. All rights reserved.
//

#import "JWTHomeViewController.h"
#import "AppDelegate.h"
#import "JWTCJZCViewController.h"

#define STARTBTN_TAG 2001
#define ENDBTN_TAG 2002
@interface JWTHomeViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIButton *_exchangeButton;
    //起点
    UILabel *_label11;
    //终点
    UILabel *_label22;
    
    UIButton *_btn1;
    
    UIButton *_btn2;
    
    UIButton *_btn3;
    
    UIButton *_checkButton;
    
}
@property (nonatomic, strong) UIButton *cityBtn;//左边城市选择
@property (nonatomic,weak) UIScrollView *scrollView;
@end
@implementation JWTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.title = @"兴途";
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
    UIButton *buttonbus = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, ScreenW/2-10, 50)];
    [buttonbus setTitle:@"  汽车票" forState:UIControlStateNormal];
    [buttonbus setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    [buttonbus setImage:[UIImage imageNamed:@"HomeIndex_busLogo_HL"] forState:UIControlStateNormal];
    [buttonbus setUserInteractionEnabled:NO];
    [self.view addSubview:buttonbus];
    
    UIButton *buttonCJZC = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW/2-10, 60, ScreenW/2+10, 50)];
    [buttonCJZC setBackgroundImage:[UIImage imageNamed:@"HomeIndex_trainBG_nor"] forState:UIControlStateNormal];
    [buttonCJZC setTitle:@"  火车票" forState:UIControlStateNormal];
    [buttonCJZC setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [buttonCJZC setImage:[UIImage imageNamed:@"HomeIndex_trainLogo_nor"] forState:UIControlStateNormal];
    [buttonCJZC addTarget:self action:@selector(checkCJZCBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCJZC];
}

//跳转到查询结果页面
-(void)checkCJZCBtnClick{
    
    JWTCJZCViewController *cjzcVC = [[JWTCJZCViewController alloc] init];
    [self.navigationController pushViewController:cjzcVC animated:NO];
    
}

@end
