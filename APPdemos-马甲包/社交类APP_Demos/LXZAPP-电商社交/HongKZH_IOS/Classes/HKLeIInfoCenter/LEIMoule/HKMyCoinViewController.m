//
//  HKMyCoinViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyCoinViewController.h"
#import "ZWMSegmentController.h"
#import "HKMySubCoinVc.h"
#import "HK_LogHeaderView.h"
@interface HKMyCoinViewController ()
@property (nonatomic, strong) ZWMSegmentController *segmentVC;
@property (nonatomic, strong)HK_LogHeaderView *head;
@end
@implementation HKMyCoinViewController
-(void)viewWillAppear:(BOOL)animated {
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"我的收益";
    [self creatSubViewControllers];
}
-(void)creatSubViewControllers {
    NSMutableArray *VCArr=[[NSMutableArray alloc] init];
    NSArray *titleArr =@[@"全部",@"收入",@"支出"];
    for (int i =0; i<titleArr.count;i++) {
        HKMySubCoinVc *coinVC =[[HKMySubCoinVc alloc] init];
        coinVC.type = i ;
        [VCArr addObject:coinVC];
    }
    self.head =[[HK_LogHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,133)];
    [self.head setTotalDetail];
    [self.view addSubview:self.head];
    self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.head.frame),kScreenWidth,self.view.bounds.size.height-CGRectGetHeight(self.head.frame)) titles:titleArr];
    self.segmentVC.segmentView.segmentTintColor = keyColor;
    self.segmentVC.segmentView.segmentNormalColor =RGB(153,153,153);
    self.segmentVC.viewControllers = VCArr;
    self.segmentVC.segmentView.style = ZWMSegmentStyleFlush;
    [self addSegmentController:self.segmentVC];
    [self.segmentVC  setSelectedAtIndex:0];
}
@end
