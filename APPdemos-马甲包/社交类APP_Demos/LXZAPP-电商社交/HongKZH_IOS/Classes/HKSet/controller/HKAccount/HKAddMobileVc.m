//
//  HKAddMobileVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddMobileVc.h"
#import "HK_CodeReceived.h"
#import "HKSetTool.h"
@interface HKAddMobileVc ()

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *seconView;
@property (nonatomic, strong)UITextField *textF;
@property (nonatomic, strong)UIButton *subMitBtn;

@end

@implementation HKAddMobileVc

-(UIView *)topView {
    if (!_topView) {
        _topView =[[UIView alloc] initWithFrame:CGRectMake(0,10,kScreenWidth,50)];
        _topView.backgroundColor =[UIColor whiteColor];
        UILabel *topLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,200,50)];
        [AppUtils getConfigueLabel:topLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"手机号归属地"];
        [_topView addSubview:topLabel];
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0,49.2,kScreenWidth,0.8)];
        line.backgroundColor = RGBA(226,226,226, 0.8);
        [_topView addSubview:line];
        
    }
    return _topView;
}
-(UIView *)seconView {
    if (!_seconView) {
        _seconView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topView.frame),kScreenWidth,CGRectGetHeight(self.topView.frame))];
        _seconView.backgroundColor =[UIColor whiteColor];
        UILabel *topLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,60,50)];
        [AppUtils getConfigueLabel:topLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"+86"];
        [_seconView addSubview:topLabel];
        self.textF =[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topLabel.frame)+8,CGRectGetMinY(topLabel.frame),kScreenWidth-CGRectGetMaxX(topLabel.frame)-8-15,CGRectGetHeight(topLabel.frame))];
        self.textF.placeholder =@"请输入手机号码";
        
        //占位符的颜色和大小
        [self.textF setValue:RGB(153,153,153) forKeyPath:@"_placeholderLabel.textColor"];
        [self.textF setValue:PingFangSCRegular15 forKeyPath:@"_placeholderLabel.font"];
        
        self.textF.textColor =[UIColor colorFromHexString:@"666666"];
        self.textF.clearButtonMode =  UITextFieldViewModeAlways;
        [_seconView addSubview:self.textF];
        [self.textF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _seconView;
}

-(UIButton *)subMitBtn {
    if (!_subMitBtn) {
        _subMitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [AppUtils getButton:_subMitBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"下一步"];
        _subMitBtn.frame =CGRectMake(30,CGRectGetMaxY(self.seconView.frame)+40,kScreenWidth-60,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_subMitBtn addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMitBtn;
}
//下一步...
-(void)subComplains {
    [HKSetTool setNewphone:self.textF.text successBlock:^{
        
          [EasyShowTextView showText:@"新手机号设置成功"];
        [self performSelector:@selector(popAfter) withObject:nil afterDelay:1];
    
    } fail:^(NSString *error) {
        
        [EasyShowTextView showText:error];
    }];
}
-(void)popAfter {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textChanged:(UITextField *)ts  {
    if (self.textF.text.length==11) {
        self.subMitBtn.backgroundColor = RGB(255,74,44);
        self.subMitBtn.enabled =YES;
    }else {
        self.subMitBtn.backgroundColor =[ UIColor colorFromHexString:@"#cccccc"];
        self.subMitBtn.enabled =NO;
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"填写手机号";
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.seconView];
    [self.view addSubview:self.subMitBtn];
}


@end
