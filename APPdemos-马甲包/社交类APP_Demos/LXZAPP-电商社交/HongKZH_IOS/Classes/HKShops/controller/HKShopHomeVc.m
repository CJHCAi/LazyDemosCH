//
//  HKShopHomeVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopHomeVc.h"
#import "ZWMSegmentController.h"
#import "HKHomeVc.h"
#import "HKGoodsVc.h"
#import "HKHotSaleVc.h"
#import "HKNewGoodsVc.h"
#import "HKShopHeadView.h"
#import "HK_ShopsDetailVc.h"
@interface HKShopHomeVc ()<sectionClickDelegete>
@property (nonatomic, strong) ZWMSegmentController *segmentVC;
@property (nonatomic, strong)HKShopHeadView *head;
@property (nonatomic, strong)HKShopResponse * response;
@end

@implementation HKShopHomeVc

-(void)initNav {
    //搜索框......
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    if (iPhone5) {
        btn.frame= CGRectMake(0,0,180,30);
    }else {
        btn.frame= CGRectMake(0,0,220,30);
    }
    [btn setImage:[UIImage imageNamed:@"class_search"] forState:UIControlStateNormal];
    [btn setTitle:@"搜索店铺内商品" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    btn.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    btn.titleLabel.font =PingFangSCRegular13;
    btn.layer.cornerRadius =15;
    btn.layer.masksToBounds =YES;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;// 垂直居中对齐
    [btn addTarget:self action:@selector(searchTagClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView  =btn;
}
-(void)searchTagClick {
    
    [AppUtils pushGoodsSearchWithCurrentVc:self];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.showCustomerLeftItem = YES;
    [self initNav];
    [self creatSubViewControllers];
    [self loadShopInfo];
    
}
#pragma mark 获取店铺信息
-(void)loadShopInfo {
    [HKShopTool getShopInfoWithShopID:self.shopId.length>0?self.shopId:@"" SuccessBlock:^(HKShopResponse *response) {
        self.response = response;
        self.head.response = response;
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)headerClick:(UITapGestureRecognizer *)to {
    HK_ShopsDetailVc * homeVC =[[HK_ShopsDetailVc alloc] init];
    homeVC.response = self.response;
    [self.navigationController pushViewController:homeVC animated:YES];
}
-(void)creatSubViewControllers {
    NSMutableArray *VCArr=[[NSMutableArray alloc] init];
    //标题数组
    NSArray *titleArr =@[@"首页",@"商品",@"热销",@"上新"];
    for (int i =0; i<titleArr.count;i++) {
        if (i!=3) {
            HKHomeVc * home =[[HKHomeVc alloc] init];
            if (i==0) {
                home.isHome = YES;
            }
            home.shopId =self.shopId;
            home.shopType = i +1;
            [VCArr addObject:home];
        }else {
         //上新
             HKNewGoodsVc * newGood =[[HKNewGoodsVc alloc] init];
            newGood.shopId =self.shopId;
            [VCArr addObject:newGood];
        }
    }
    //上部视图店铺信息视图..
    self.head =[[HKShopHeadView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,87)];
    //加点击事件/
    UITapGestureRecognizer * tapH =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick:)];
    self.head.userInteractionEnabled =YES;
    [self.head addGestureRecognizer:tapH];
    self.head.delegete = self;
    [self.view addSubview:self.head];
    self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.head.frame),kScreenWidth,self.view.bounds.size.height-CGRectGetHeight(self.head.frame)) titles:titleArr];
    self.segmentVC.segmentView.segmentTintColor = RGB(239,89,60);
    self.segmentVC.segmentView.segmentNormalColor =RGB(153,153,153);
    self.segmentVC.viewControllers = VCArr;
    self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
    [self addSegmentController:self.segmentVC];
    [self.segmentVC  setSelectedAtIndex:0];
}
-(void)saveBlock:(HKShopResponse *)response{
    [HKShopTool collectionShopOrNot:response successBlock:^{
        if (response.data.isCollect) {
            
            [self.head.saveBtn setImage:[UIImage imageNamed:@"dp_sc"] forState:UIControlStateNormal];
            self.head.response.data.isCollect =0;
            [EasyShowTextView showText:@"取消成功"];
        }else {
            [self.head.saveBtn setImage:[UIImage imageNamed:@"dp_ysc"] forState:UIControlStateNormal];
            self.head.response.data.isCollect =1;
            [EasyShowTextView showText:@"收藏成功"];
        }
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
@end
