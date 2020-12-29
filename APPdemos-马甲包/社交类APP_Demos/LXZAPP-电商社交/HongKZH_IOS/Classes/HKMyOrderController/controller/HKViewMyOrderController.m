//
//  HKViewMyOrderController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKViewMyOrderController.h"
#import "HK_baseSubOrderVc.h"
#import "ZWMSegmentController.h"
#import "HK_searchOrderController.h"
@interface HKViewMyOrderController ()

@property (nonatomic, strong) ZWMSegmentController *segmentVC;
@end

@implementation HKViewMyOrderController

-(instancetype)init {
    self =[super init];
    if (self) {
        self.sx_disableInteractivePop = YES;
    }
    return  self;
}
-(void)initNav {
    self.title =@"我的订单";
    [self setShowCustomerLeftItem:YES];
    [AppUtils addBarButton:self title:@"search" action:@selector(pushSearchVc) position:PositionTypeRight];
}
-(void)pushSearchVc {
    HK_searchOrderController * searchVc =[[HK_searchOrderController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppUtils setPopHidenNavBarForFirstPageVc:self];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    [self creatSubViewControllers];
}
-(void)creatSubViewControllers {
    NSMutableArray *vcArray=[[NSMutableArray alloc] init];
    //标题数组
    NSArray *titleArr =@[@"全部",@"待付款",@"待分享",@"待收货",@"已完成",@"已取消"];
    NSArray * statusArr =@[@"0",@"1",@"100",@"3",@"7",@"8"];
    for (int i=0; i<titleArr.count;i++) {
        HK_baseSubOrderVc *pageVc = [[HK_baseSubOrderVc alloc] init];
        pageVc.tradeString = statusArr[i];
        [vcArray addObject:pageVc];
    }
    self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:self.view.bounds titles:titleArr];
    
    self.segmentVC.segmentView.segmentTintColor = [UIColor colorFromHexString:@"333333"];
    self.segmentVC.segmentView.segmentNormalColor =[UIColor colorFromHexString:@"666666"];
    
    self.segmentVC.viewControllers = vcArray;
    self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
    //指示条和按钮文字对其
    [self addSegmentController:self.segmentVC];
    [self.segmentVC  setSelectedAtIndex:0];
    
}

@end
