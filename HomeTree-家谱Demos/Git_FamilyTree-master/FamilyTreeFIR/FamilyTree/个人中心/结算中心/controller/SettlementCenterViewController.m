//
//  SettlementCenterViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "SettlementCenterViewController.h"
#import "CommonNavigationViews.h"
#import "RechargeViewController.h"


@interface SettlementCenterViewController ()
/** 订单信息数组*/
@property (nonatomic, strong) NSArray *orderListArr;

@end

@implementation SettlementCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonNavigationViews *navi = [[CommonNavigationViews alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64) title:@"结算中心" image:MImage(@"chec")];
    [self.view addSubview:navi];
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    bgIV.image = MImage(@"bg");
    [self.view addSubview:bgIV];
    //主视图
    [self initMainView];
    
}

-(void)initMainView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.0438*Screen_width, 0.1438*Screen_height, 0.9156*Screen_width, 0.4225*Screen_height)];
    bgView.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:0.5];
    [self.view addSubview:bgView];
    //黑色边框
    UIView *blackBorderBgView = [[UIView alloc]initWithFrame:CGRectMake(0.0444*CGRectW(bgView), 0.0542*CGRectH(bgView), 0.9283*CGRectW(bgView), 0.4708*CGRectH(bgView))];
    blackBorderBgView.layer.borderWidth = 1;
    blackBorderBgView.layer.borderColor = [UIColor blackColor].CGColor;
    [bgView addSubview:blackBorderBgView];
    
    NSArray *categoryArr = @[@"订单商品",@"用户账号",@"商品价格",@"金币余额"];
    for (int i = 0; i < 4; i++) {
        //左边类别
        UILabel *categoryLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectH(blackBorderBgView)/4*i, 0.3125*CGRectW(blackBorderBgView), CGRectH(blackBorderBgView)/4)];
        categoryLB.text = categoryArr[i];
        categoryLB.textAlignment = NSTextAlignmentCenter;
        categoryLB.font = MFont(14);
        categoryLB.layer.borderColor = LH_RGBCOLOR(133, 134, 135).CGColor;
        categoryLB.layer.borderWidth = 0.5;
        [blackBorderBgView addSubview:categoryLB];
        //右边订单详情
        UIView *orderListView = [[UIView alloc]initWithFrame:CGRectMake(CGRectXW(categoryLB), CGRectY(categoryLB), 0.6875*CGRectW(blackBorderBgView), CGRectH(blackBorderBgView)/4)];
        orderListView.layer.borderColor = LH_RGBCOLOR(133, 134, 135).CGColor;
        orderListView.layer.borderWidth = 0.5;
        [blackBorderBgView addSubview:orderListView];
        UILabel *orderListLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.6875*CGRectW(blackBorderBgView)-15, CGRectH(blackBorderBgView)/4)];
        if ([self.orderListArr[i] isKindOfClass:[NSString class]]) {
            orderListLB.text = self.orderListArr[i];
        }else{
            orderListLB.text = [NSString stringWithFormat:@"%@元",self.orderListArr[i]];
        }
        orderListLB.textAlignment = NSTextAlignmentLeft;
        orderListLB.font = MFont(14);
        [orderListView addSubview:orderListLB];
        //刷新按钮
        if (i == 3) {
            UIButton *refreshBalanceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.3529*CGRectW(orderListView), 0.1667*CGRectH(orderListView), 0.3476*CGRectW(orderListView), 0.6667*CGRectH(orderListView))];
            [refreshBalanceBtn setBackgroundImage:MImage(@"zfzg_shuaXin") forState:UIControlStateNormal];
            [refreshBalanceBtn addTarget:self action:@selector(clickRefreshBalanceBtn:) forControlEvents:UIControlEventTouchUpInside];
            [orderListView addSubview:refreshBalanceBtn];
        }
    }
    //提示语
    UILabel *tipLB = [[UILabel alloc]initWithFrame:CGRectMake(0.0546*CGRectW(bgView), 0.5729*CGRectH(bgView), 0.5846*CGRectW(bgView), 0.0917*CGRectH(bgView))];
    tipLB.text = self.orderListArr[2]>self.orderListArr[3]?@"余额不足，请先充值，再购买。":@"";
    tipLB.font = MFont(12);
    [bgView addSubview:tipLB];
    
    //确认或者充值按钮
    UIButton *sureOrPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0546*CGRectW(bgView), 0.7542*CGRectH(bgView), 0.8908*CGRectW(bgView), 0.1458*CGRectH(bgView))];
    [sureOrPayBtn setTitle:self.orderListArr[2]>self.orderListArr[3]?@"充值":@"确认购买" forState:UIControlStateNormal];
    sureOrPayBtn.backgroundColor = LH_RGBCOLOR(219, 222, 220);
    [sureOrPayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureOrPayBtn addTarget:self action:@selector(clickSureOrPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureOrPayBtn];
    
}

#pragma mark - lazyLoad
-(NSArray *)orderListArr{
    if (!_orderListArr) {
        _orderListArr = @[@"6个月",@"chenyi",@120,@188];
    }
    return _orderListArr;
}

-(void)clickRefreshBalanceBtn:(UIButton *)sender{
    MYLog(@"刷新余额");
    //发送请求得到余额
}

-(void)clickSureOrPayBtn:(UIButton *)sender{
    //MYLog(@"%@",sender.titleLabel.text);
    if (self.orderListArr[2]>self.orderListArr[3]) {
        RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
@end
