//
//  HKUpdateCicleNameVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateCicleNameVc.h"

@interface HKUpdateCicleNameVc ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField * nameTF;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UILabel *tipsLabel;
@end
@implementation HKUpdateCicleNameVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.updateName ? @"修改圈子名称":@"修改圈子简介";
    [self setrightBarButtonItemWithTitle:@"保存"];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.line];
    [self.view addSubview:self.tipsLabel];
    self.nameTF.text = self.name;
}
-(void)rightBarButtonItemClick {
    if (self.nameTF.text.length <2 || self.nameTF.text.length >20) {
        [EasyShowTextView showText:@"请输入指定内容"];
        return;
    }
    if (self.block) {
        self.block(self.nameTF.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF =[[UITextField alloc] initWithFrame:CGRectMake(15,30,kScreenWidth-30,45)];
        _nameTF.placeholder = self.updateName ? @"填写圈子名称":@"填写圈子简介";
        _nameTF.clearButtonMode =  UITextFieldViewModeWhileEditing;
        [_nameTF setValue:RGB(153,153,153) forKeyPath:@"_placeholderLabel.textColor"];
        [_nameTF setValue:PingFangSCRegular14 forKeyPath:@"_placeholderLabel.font"];
        _nameTF.borderStyle  =UITextBorderStyleNone;
        _nameTF.returnKeyType =UIReturnKeyDone;
        _nameTF.textColor =[UIColor colorFromHexString:@"333333"];
        _nameTF.font =PingFangSCRegular14;
    }
    return _nameTF;
}
-(UIView *)line {
    if (!_line) {
        _line =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameTF.frame),CGRectGetMaxY(self.nameTF.frame)+1,CGRectGetWidth(self.nameTF.frame),0.5)];
        _line.backgroundColor =[UIColor colorFromHexString:@"999999"];
    }
    return _line;
}
-(UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.line.frame),CGRectGetMaxY(self.line.frame)+5,CGRectGetWidth(self.line.frame),10)];
        [AppUtils getConfigueLabel:_tipsLabel font:PingFangSCRegular12 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@"2至24个字符,不含连续空格"];
    }
    return _tipsLabel;
}
@end
