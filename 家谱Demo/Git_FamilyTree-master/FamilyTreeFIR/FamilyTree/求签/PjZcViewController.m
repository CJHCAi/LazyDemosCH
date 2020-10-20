//
//  PjZcViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/19.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PjZcViewController.h"

@interface PjZcViewController()
/** 背景图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 破解方法*/
@property (nonatomic, strong) UITextView *pjTV;
/** 返回主页按钮*/
@property (nonatomic, strong) UIButton *backToMainBtn;
@end

@implementation PjZcViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.backIV];
    [self.backIV addSubview:self.pjTV];
    [self.backIV addSubview:self.backToMainBtn];
}

#pragma mark - lazyLoad
-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backIV.userInteractionEnabled = YES;
        _backIV.image = MImage(@"zcmf_bg");
    }
    return _backIV;
}

-(UITextView *)pjTV{
    if (!_pjTV) {
        _pjTV = [[UITextView alloc]initWithFrame:CGRectMake(0.1594*CGRectW(self.backIV), 0.5231*CGRectH(self.backIV), 0.7344*CGRectW(self.backIV), 0.3077*CGRectH(self.backIV))];
        _pjTV.backgroundColor = [UIColor clearColor];
        _pjTV.editable = NO;
        _pjTV.text = [self.lotteryPoetryModel.pj stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        _pjTV.font = MFont(13);
        _pjTV.textAlignment = NSTextAlignmentCenter;
        _pjTV.bounces = NO;
    }
    return _pjTV;
}

-(UIButton *)backToMainBtn{
    if (!_backToMainBtn) {
        _backToMainBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.3375*CGRectW(self.backIV), 0.8967*CGRectH(self.backIV), 0.3906*CGRectW(self.backIV), 0.0681*CGRectH(self.backIV))];
        [_backToMainBtn setBackgroundImage:MImage(@"zcmf_btn") forState:UIControlStateNormal];
        [_backToMainBtn addTarget:self action:@selector(clickBtnBackToMain) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToMainBtn;
}

-(void)clickBtnBackToMain{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
