//
//  PuzzleViewController.m
//  PicturePuzzle
//
//  Created by JSB - Leidong on 17/6/6.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "VideoHandleViewController.h"
#import "UrlViewController.h"

@interface VideoHandleViewController ()

@end

@implementation VideoHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNaviItem];
    
    [self createUI];
}
//
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航栏的字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
//定制navigationItem
-(void)customNaviItem{
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 160, 44)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"视频处理";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    self.navigationItem.titleView = titleLab;
    
    //自定义返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftBtn.frame = CGRectMake(0, 0, 50, 44);
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"p_top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
}


#pragma mark - 自定义UI
#pragma mark -
//拼长图和图片拼接
-(void)createUI{
    
    CGFloat height = (SCREENHEIGHT - 64 - 50 - 12 * 3) / 2;
    CGFloat width = SCREENWIDTH - 12 * 2;
    
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"spcl_spxz_bg"];
    firstBtn.tag = 1;
    //指定范围拉伸图片
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2, image.size.width / 2)];
    [firstBtn setBackgroundImage:image forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:@"spcl_spxz"] forState:UIControlStateNormal];
    [self.view addSubview:firstBtn];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(12);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    [firstBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image2 = [UIImage imageNamed:@"spcl_spbj_bg"];
    secondBtn.tag = 2;
    //指定范围拉伸图片
    image2 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(image2.size.height / 2, image2.size.width / 2, image2.size.height / 2, image2.size.width / 2)];
    [secondBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    [secondBtn setImage:[UIImage imageNamed:@"spcl_spbj"] forState:UIControlStateNormal];
    [self.view addSubview:secondBtn];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(firstBtn.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
        make.size.mas_equalTo(firstBtn);
    }];
    [secondBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //底部广告
    [self createAD];
}
//广告位
-(void)createAD{

    UIView *adView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 50 - 64, SCREENWIDTH, 50)];
    
    [self.view addSubview:adView];
}


#pragma mark - 各种事件
#pragma mark -
//返回
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//
-(void)clickAction:(UIButton *)sender{

    if (sender.tag == 1) {
        
        UrlViewController *ctl = [UrlViewController new];
    
        [self.navigationController pushViewController:ctl animated:YES];
        
    }else{
    
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"xiaoshipin"]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"xiaoshipin"]];
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"视频编辑功能由小视频神器提供服务支持，是否进行下载？" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1167278013"]];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
