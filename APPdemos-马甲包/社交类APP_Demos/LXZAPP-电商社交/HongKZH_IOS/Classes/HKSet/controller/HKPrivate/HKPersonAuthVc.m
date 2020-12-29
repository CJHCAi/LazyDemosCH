//
//  HKPersonAuthVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//
////个人认证中
#import "HKPersonAuthVc.h"
#import "HKRealNameAuthViewController.h"
@interface HKPersonAuthVc ()
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong)UIButton *subMitBtn;
@property (nonatomic, strong)UIImageView * rootImageV;
@property (nonatomic, strong)UILabel *tipsOne;
@property (nonatomic, strong)UILabel *tipsTwo;
@property (nonatomic, strong)UILabel *tipsThree;
@end

@implementation HKPersonAuthVc
-(UIButton *)subMitBtn {
    if (!_subMitBtn) {
        _subMitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [AppUtils getButton:_subMitBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@""];
        if (self.state ==1) {
            [_subMitBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else if (self.state ==3){
            [_subMitBtn setTitle:@"重新认证" forState:UIControlStateNormal];
        }
        _subMitBtn.frame =CGRectMake(30,kScreenHeight-StatusBarHeight-NavBarHeight-30-49-SafeAreaBottomHeight,kScreenWidth-60,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.backgroundColor =RGB(255,74,44);
        [_subMitBtn addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMitBtn;
}

-(void)subComplains {
    if (self.state==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.state ==3) {
        HKRealNameAuthViewController *vc  =[[HKRealNameAuthViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(UIView *)topV {
    if (!_topV) {
        _topV =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        _topV.backgroundColor = MainColor
    }
    return _topV;
}
-(UIImageView *)rootImageV {
    if (!_rootImageV) {
        _rootImageV =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-50,CGRectGetMaxY(self.topV.frame)+150,100,100)];
        _rootImageV.backgroundColor = MainColor
        _rootImageV.layer.cornerRadius =50;
        _rootImageV.layer.masksToBounds =YES;
        UIImageView * stateV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_rootImageV.frame)/2-20,CGRectGetHeight(_rootImageV.frame)/2-20,40,40)];
        if (self.state==1) {
            stateV.image =[UIImage imageNamed:@"shenhezhong"];
        }else if (self.state ==3) {
            stateV.image =[UIImage imageNamed:@"shenhefail"];
        }
        [_rootImageV addSubview:stateV];
    }
    return _rootImageV;
}
-(UILabel *)tipsOne {
    if (!_tipsOne) {
        _tipsOne =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.rootImageV.frame)+30,kScreenWidth,25)];
        [AppUtils getConfigueLabel:_tipsOne font:PingFangSCMedium20 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        if (self.state==1) {
            _tipsOne.text =@"认证审核中...";
        }else if (self.state ==3) {
            _tipsOne.text = @"审核未通过";
        }
    }
    return _tipsOne;
}
-(UILabel *)tipsTwo {
    if (!_tipsTwo) {
        _tipsTwo =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tipsOne.frame)+20,kScreenWidth,14)];
        [AppUtils getConfigueLabel:_tipsTwo font:PingFangSCRegular15     aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
        if (self.state==1) {
            _tipsTwo.text =@"您的资料已提交成功,请耐心等待";
        }else if (self.state ==3) {
            _tipsTwo.text = @"对不起,您的信息审核未通过,";
        }
    }
    return _tipsTwo;
}
-(UILabel *)tipsThree {
    if (!_tipsThree) {
        _tipsThree =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tipsTwo.frame)+10,kScreenWidth,14)];
        [AppUtils getConfigueLabel:_tipsThree font:PingFangSCRegular15     aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
        if (self.state==1) {
            _tipsThree.text =@"";
        }else if (self.state ==3) {
          _tipsThree.text = @"请修改信息并再次尝试";
        }
    }
    return _tipsThree;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor =[UIColor whiteColor];
    self.showCustomerLeftItem =YES;
    [self.view addSubview:self.topV];
    [self.view addSubview:self.rootImageV];
    [self.view addSubview:self.tipsOne];
    [self.view addSubview:self.tipsTwo];
    [self.view addSubview:self.tipsThree];
    [self.view addSubview:self.subMitBtn];
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
@end
