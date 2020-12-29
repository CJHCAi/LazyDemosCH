//
//  HKRealAuthResultVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRealAuthResultVc.h"

@interface HKRealAuthResultVc ()

//chenggong

@end

@implementation HKRealAuthResultVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交审核";
    self.showCustomerLeftItem = YES;
    self.sx_disableInteractivePop = YES;
    
    [self setSubViews];
}
-(void)backItemClick {
    //pop到设置页面..
    Class  vc = NSClassFromString(@"HKSetingVc");
    
    for(UIViewController *temVC in self.navigationController.viewControllers)
    {
        if ([temVC  isKindOfClass:vc]) {
            
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}

-(void)setSubViews {
    UIImage * cer =[UIImage imageNamed:@"chenggong"];
    UIImageView * im =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-cer.size.width/2,200,cer.size.width,cer.size.height)];
    im.image = cer;
    [self.view addSubview:im];
   
    UILabel *successLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(im.frame)+15,kScreenWidth,20)];
    [AppUtils getConfigueLabel:successLabel font:PingFangSCMedium18 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"提交成功"];
    [self.view addSubview:successLabel];
    
    UILabel *tipsOne =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(successLabel.frame)+20,kScreenWidth,10)
                       ];
    [AppUtils getConfigueLabel:tipsOne font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"999999"] text:@"乐小转工作人员会尽快与您联系;"];
    [self.view addSubview:tipsOne];
    
    UILabel *tipTwo=[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(tipsOne.frame)+10,kScreenWidth,10)];
    [AppUtils getConfigueLabel:tipTwo font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"999999"] text:@"您也可以主动联系我们咨询合作事宜"];
    [self.view addSubview:tipTwo];
    
    UILabel *parterLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,kScreenHeight-NavBarHeight-StatusBarHeight -40 -10,kScreenWidth,10)];
    [self.view addSubview:parterLabel];
    [AppUtils getConfigueLabel:parterLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"999999"] text:@"商务合作热线: 010-87654321(9:00-22:00)"];

    
}
@end
