//
//  VIPSelectViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "VIPSelectViewController.h"
#import "CommonNavigationViews.h"
#import "SettlementCenterViewController.h"

@interface VIPSelectViewController ()
/** vip价格数组*/
@property (nonatomic, strong) NSArray *priceArr;
@end

@implementation VIPSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonNavigationViews *navi = [[CommonNavigationViews alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64) title:@"会员套餐" image:MImage(@"chec")];
    [self.view addSubview:navi];
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    bgIV.image = MImage(@"bg");
    [self.view addSubview:bgIV];
    
    //主视图
    [self initMainView];
    
}

-(void)initMainView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.04375*CGRectW(self.view), 0.1338*CGRectH(self.view), 0.9125*CGRectW(self.view), 0.4*CGRectH(self.view))];
    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    //会员套餐
    UILabel *VIPPlanLB = [[UILabel alloc]initWithFrame:CGRectMake(0.0479*CGRectW(bgView), 0.0658*CGRectH(bgView), 0.2089*CGRectW(bgView), 0.1154*CGRectH(bgView))];
    VIPPlanLB.text = @"会员套餐";
    VIPPlanLB.font = MFont(15);
    [bgView addSubview:VIPPlanLB];
    
    //时间对应价格
    self.priceArr = @[@"1个月30元",@"3个月75元",@"6个月120元",@"12个月188元"];
    for (int i = 0; i < 4; i++) {
        //价格
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(VIPPlanLB), 0.2692*CGRectH(bgView)+0.1923*CGRectH(bgView)*i, 0.2740*CGRectW(bgView), 0.0824*CGRectH(bgView))];
        label.text = self.priceArr[i];
        label.font = MFont(13);
        [bgView addSubview:label];
        //line
        if (i < 3){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.3984*CGRectH(bgView)+0.1923*CGRectH(bgView)*i, CGRectW(bgView), 1)];
            lineView.backgroundColor = LH_RGBCOLOR(214, 214, 214);
            [bgView addSubview:lineView];
            
        }
        //开通
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0.7140*CGRectW(bgView), 0.2335*CGRectH(bgView)+0.1923*CGRectH(bgView)*i, 0.2397*CGRectW(bgView), 0.1319*CGRectH(bgView))];
        [button setTitle:@"开通" forState:UIControlStateNormal];
        button.backgroundColor = LH_RGBCOLOR(75, 88, 91);
        button.titleLabel.font = MFont(13);
        button.tag = 101+i;
        [button addTarget:self action:@selector(clickOpenVIPBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
    }
}

-(void)clickOpenVIPBtn:(UIButton *)sender{
    MYLog(@"开通%@",self.priceArr[sender.tag-101]);
    SettlementCenterViewController *settlemetCenterVC = [[SettlementCenterViewController alloc]init];
    [self.navigationController pushViewController:settlemetCenterVC animated:YES];
}

@end
