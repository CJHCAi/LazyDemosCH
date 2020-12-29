//
//  HKLaunchCollageVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLaunchCollageVc.h"
#import "HK_BaseRequest.h"
#import "HK_UserInfoDataModel.h"
#import "HK_RechargeController.h"
#import "HKCollageDetailVc.h"
#import "HKCounponTool.h"
#import "CountDown.h"
#import "HKCollageOrderResponse.h"
//发起拼单 失败和成功...
@interface HKLaunchCollageVc ()

@property (nonatomic, strong) UIImageView * showV;
@property (nonatomic, strong) UILabel * showL;
@property (nonatomic, strong)UILabel *endTimeLabel;
@property (nonatomic, strong)CountDown *countDown;
@property (nonatomic, strong)HKCollageOrderResponse *response;

@end

@implementation HKLaunchCollageVc

-(void)initNav {
    self.showCustomerLeftItem =YES;
//  //当前用户乐币 和拼单所需要乐币进行比较....
//    [HK_BaseRequest buildPostRequest:get_usergetUserIntegral body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
//        HK_UserInfoDataModel * model =[HK_UserInfoDataModel mj_objectWithKeyValues:responseObject];
//        if (!model.code) {
//            [LoginUserData sharedInstance].integral = model.data.integral;
//            if (model.data.integral >= 10 ) {
//                self.title = @"发起成功";
//                [self successUI];
//
//            }else {
//                self.title =@"发起失败";
//                [self failUI];
//            }
//        }else {
//            [EasyShowTextView showText:@"获取用户乐币失败"];
//        }
//    } failure:^(NSError * _Nullable error) {
//    }];
    if (self.successLunch) {
        self.title = @"发起成功";
        [self successUI];
       //获取订单详情....
        [HKCounponTool getCollageOrderInfo:self.orderId successBlock:^(HKCollageOrderResponse *response) {
            self.response = response;
            } fail:^(NSString *error) {
                
            }];
    }else {
        self.title =@"发起失败";
        [self failUI];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UIView * sub  in self.view.subviews) {
        [sub removeFromSuperview];
    }
    [self initNav];
}
- (void)viewDidLoad {
     [super viewDidLoad];
    if (self.successLunch) {
        self.countDown = [[CountDown alloc] init];
        ///每秒回调一次
        [self.countDown countDownWithPER_SECBlock:^{
            self.endTimeLabel.text =[HKCounponTool getConponLastStringWithEndString:self.response.data.endTime];
        }];
    }
}
#pragma mark 发起成功
-(void)successUI {
    UIImage *successM =[UIImage imageNamed:@"collageSuccess"];
    self.showV =[[UIImageView alloc] initWithFrame: CGRectMake(kScreenWidth/2-successM.size.width/2,90,successM.size.width,successM.size.height)];
    self.showV.image =successM;
    self.showV.layer.cornerRadius = successM.size.width/2;
    self.showV.layer.masksToBounds =YES;
    [self.view addSubview:self.showV];
    self.showL =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.showV.frame)+15,kScreenWidth,17)];
    [self.view addSubview:self.showL];
    [AppUtils getConfigueLabel:self.showL font:[UIFont boldSystemFontOfSize:17] aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"发起成功"];
    //提示..
    UILabel * tipsL =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.showL.frame)+30,kScreenWidth,20)];
    [AppUtils getConfigueLabel:tipsL font:PingFangSCRegular14 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    [self.view addSubview:tipsL];
    NSString *tips =@"还差1人，赶快邀请好友拼单吧!";
    NSMutableAttributedString * attibue =[[NSMutableAttributedString alloc] initWithString:tips];
    [attibue addAttribute:NSForegroundColorAttributeName value:RGB(227,90,19) range:NSMakeRange(2,1)];
    tipsL.attributedText = attibue;
   //头像组....
    UIImageView *phoneO =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-10-45,CGRectGetMaxY(tipsL.frame)+25,45,45)];
    phoneO.layer.cornerRadius =45/2;
    phoneO.layer.masksToBounds = YES;
    [AppUtils seImageView:phoneO withUrlSting:[LoginUserData sharedInstance].headImg placeholderImage:[UIImage imageNamed:@"enterprise_bg"]];
    [self.view addSubview:phoneO];
    
    UIImageView *invater =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2+10,CGRectGetMinY(phoneO.frame),CGRectGetWidth(phoneO.frame),CGRectGetHeight(phoneO.frame))];
    invater.layer.cornerRadius =45/2;
    invater.layer.masksToBounds = YES;
    invater.image =[UIImage imageNamed:@"Combined Shape"];
    [self.view addSubview:invater];
   //邀请按钮
    UIButton * invateBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    invateBtn.frame= CGRectMake(kScreenWidth/2-150,CGRectGetMaxY(invater.frame)+35,300,43);
    [AppUtils getButton:invateBtn font:PingFangSCMedium16 titleColor:[UIColor whiteColor] title:@"邀请好友拼单"];
    invateBtn.layer.cornerRadius =12;
    invateBtn.layer.masksToBounds =YES;
    invateBtn.backgroundColor =RGB(239,89,60);
    [invateBtn addTarget:self action:@selector(invateSomeOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invateBtn];
   //结束倒计时
    UILabel * endTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(invateBtn.frame)+15,kScreenWidth,12)];
    self.endTimeLabel = endTimeLabel;
    [AppUtils getConfigueLabel:endTimeLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:RGB(102,102,102) text:@""];
    [self.view addSubview:endTimeLabel];
}
#pragma  mark 拼单成功 ->点击邀请进入拼团详情
-(void)invateSomeOne {
    HKCollageDetailVc * detailVC =[[HKCollageDetailVc alloc] init];
    detailVC.orderId = self.orderId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark 发起失败
-(void)failUI {
    UIImage *imageF =[UIImage imageNamed:@"collageFail"];
    self.showV =[[UIImageView alloc] initWithFrame: CGRectMake(kScreenWidth/2-imageF.size.width/2,90,imageF.size.width,imageF.size.height)];
    self.showV.image =[UIImage imageNamed:@"crowd_Bg1"];
    self.showV.layer.cornerRadius = imageF.size.width/2;
    self.showV.layer.masksToBounds =YES;
    [self.view addSubview:self.showV];
    self.showL =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.showV.frame)+15,kScreenWidth,17)];
    [self.view addSubview:self.showL];
    [AppUtils getConfigueLabel:self.showL font:[UIFont boldSystemFontOfSize:17] aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"发起失败"];
   //提示..
    UILabel * tipsL =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.showL.frame)+30,kScreenWidth,14)];
    [AppUtils getConfigueLabel:tipsL font:PingFangSCRegular14 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    [self.view addSubview:tipsL];
    if ([LoginUserData sharedInstance].integral >=self.intergal) {
        tipsL.text = self.failMessage;
        //返回首页
        UIButton * backB =[UIButton buttonWithType:UIButtonTypeCustom];
        backB.frame = CGRectMake(kScreenWidth/2-150/2,CGRectGetMaxY(tipsL.frame)+40,150,43);
        [AppUtils getButton:backB font:PingFangSCRegular15 titleColor:[UIColor whiteColor] title:@"返回首页"];
        backB.layer.cornerRadius =20;
        backB.layer.masksToBounds  =YES;
        [self.view addSubview:backB];
        backB.backgroundColor =RGB(239,89,60);
        [backB addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        
        NSString *tips =@"您发起拼单的乐币不足，请充值!";
        NSMutableAttributedString * attibue =[[NSMutableAttributedString alloc] initWithString:tips];
        [attibue addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"333333"] range:NSMakeRange(6,2)];
        [attibue addAttribute:NSForegroundColorAttributeName value:RGB(239,89,60) range:NSMakeRange(6, 2)];
        tipsL.attributedText = attibue;
        //返回首页
        UIButton * backB =[UIButton buttonWithType:UIButtonTypeCustom];
        backB.frame = CGRectMake(kScreenWidth/2-10-150,CGRectGetMaxY(tipsL.frame)+40,150,43);
        [AppUtils getButton:backB font:PingFangSCRegular15 titleColor:[UIColor whiteColor] title:@"返回首页"];
        backB.layer.cornerRadius =20;
        backB.layer.masksToBounds  =YES;
        [self.view addSubview:backB];
        backB.backgroundColor =RGB(239,89,60);
        [backB addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        //去充值
        UIButton *supLyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        supLyBtn.frame= CGRectMake(kScreenWidth/2+10,CGRectGetMinY(backB.frame),CGRectGetWidth(backB.frame),CGRectGetHeight(backB.frame));
        [AppUtils getButton:supLyBtn font:PingFangSCRegular15 titleColor:RGB(239,89,60) title:@"去充值"];
        supLyBtn.layer.cornerRadius =20;
        supLyBtn.layer.masksToBounds  =YES;
        [self.view addSubview:supLyBtn];
        supLyBtn.layer.borderWidth =1;
        supLyBtn.layer.borderColor =[RGB(239,89,60) CGColor];
        supLyBtn.backgroundColor =[UIColor whiteColor];
        [supLyBtn addTarget:self action:@selector(chargeCLick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)chargeCLick:(UIButton *)sender {
    HK_RechargeController * chare =[[HK_RechargeController alloc] init];
    [self.navigationController pushViewController:chare animated:YES];
}

@end
