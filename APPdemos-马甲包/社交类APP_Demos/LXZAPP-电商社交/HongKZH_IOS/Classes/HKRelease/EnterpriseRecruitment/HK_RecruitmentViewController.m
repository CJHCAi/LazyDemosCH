//
//  HK_RecruitmentViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_RecruitmentViewController.h"
#import "RecruitAccountChoiceView.h"
#import "HK_EnterpriseCertificationViewController.h"
#import "HKVideoRecordTool.h"

@interface HK_RecruitmentViewController ()
@property (nonatomic,strong) HKVideoRecordTool *tool;
@end

@implementation HK_RecruitmentViewController

- (HKVideoRecordTool *)tool {
    if (!_tool) {
        _tool = [HKVideoRecordTool videoRecordWithDelegate:self];
    }
    return _tool;
}

#pragma mark Nav 设置
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//设置左侧取消按钮
- (void)setLeftNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择账户类型";
    [self setLeftNavItem];
    [self setUpUI];
 
}

#pragma mark UI

#define TIP @"请选择您的账户类型"
#define SMALLTIP @"提示: 请谨慎选择,账户类型无法再次更改"
#define CHOICE1 @"我是求职者"
#define CHOICE2 @"我是企业"

- (void)setUpUI {
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recruitbg1"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-10);
    }];
    //Tip 提示 Label
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = TIP;
    tipLabel.font = [UIFont fontWithName:PingFangSCMedium size:19];
    tipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView).offset(116);
    }];
    //小提示
    //Tip 提示 Label
    UILabel *smallTipLabel = [UILabel new];
    smallTipLabel.text = SMALLTIP;
    smallTipLabel.font = [UIFont fontWithName:PingFangSCRegular size:12];
    smallTipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:smallTipLabel];
    [smallTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView).offset(148);
    }];
    
    //"我是求职者"视图
    RecruitAccountChoiceView *choiceView1 = [RecruitAccountChoiceView viewWithImage:[UIImage imageNamed:@"qiuzhi"] text:CHOICE1 color:RGB(237, 155, 95)];
    [self.view addSubview:choiceView1];
    [choiceView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(307);
        make.top.mas_equalTo(227);
        make.height.mas_equalTo(99);
    }];
    //设置圆角
    choiceView1.layer.cornerRadius = 10.f;
    choiceView1.layer.masksToBounds = YES;
    //添加事件
    [choiceView1 addTarget:self action:@selector(choice1) forControlEvents:UIControlEventTouchUpInside];

    //"我是企业"视图
    RecruitAccountChoiceView *choiceView2 = [RecruitAccountChoiceView viewWithImage:[UIImage imageNamed:@"woshiqiye"] text:CHOICE2 color:RGB(95, 145, 237)];
    [self.view addSubview:choiceView2];
    [choiceView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(choiceView1);
        make.top.mas_equalTo(choiceView1.mas_bottom).offset(19);
        make.height.mas_equalTo(choiceView1);
    }];
    //设置圆角
    choiceView2.layer.cornerRadius = 10.f;
    choiceView2.layer.masksToBounds = YES;
    //添加事件
    [choiceView2 addTarget:self action:@selector(choice2) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 事件处理


/**
 我是求职者点击事件,跳转到视频录制页面
 */
- (void)choice1 {
    DLog(@"%@",CHOICE1);
    [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypeResume;
    [self.tool toRecordView];
}

//我是企业点击事件
- (void)choice2 {
    DLog(@"%@",CHOICE2);
    HK_EnterpriseCertificationViewController *vc = [[HK_EnterpriseCertificationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
