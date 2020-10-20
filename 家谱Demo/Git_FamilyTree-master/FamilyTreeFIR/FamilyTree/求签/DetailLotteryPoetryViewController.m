//
//  DetailLotteryPoetryViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/18.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "DetailLotteryPoetryViewController.h"
#import "PjView.h"
#import "PjZcViewController.h"

@interface DetailLotteryPoetryViewController()<PjViewDelegate>
/** 背景图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 初解背景图*/
@property (nonatomic, strong) UIImageView *initialBackIV;
/** 详解1*/
@property (nonatomic, strong) UITextView *detailFirstTX;
/** 详解2*/
@property (nonatomic, strong) UITextView *detailSecondTX;
/** 返回主页按钮*/
@property (nonatomic, strong) UIButton *backToMainBtn;
/** 破解之法按钮*/
@property (nonatomic, strong) UIButton *pjBtn;
@end

@implementation DetailLotteryPoetryViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.backIV];
    [self.backIV addSubview:self.initialBackIV];
    [self.initialBackIV addSubview:self.detailFirstTX];
    [self.initialBackIV addSubview:self.detailSecondTX];
    [self.backIV addSubview:self.backToMainBtn];
    [self.backIV addSubview:self.pjBtn];
}

#pragma mark - lazyLoad
-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backIV.image = MImage(@"cq_bg");
        _backIV.userInteractionEnabled = YES;
    }
    return _backIV;
}

-(UIImageView *)initialBackIV{
    if (!_initialBackIV) {
        _initialBackIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.05*CGRectW(self.backIV), 0.0274*CGRectW(self.backIV), 0.909375*CGRectW(self.backIV), 0.8154*CGRectH(self.backIV))];
        _initialBackIV.image = MImage(@"xj_bg_ct");
        _initialBackIV.userInteractionEnabled = YES;
    }
    return _initialBackIV;
}

-(UITextView *)detailFirstTX{
    if (!_detailFirstTX) {
        _detailFirstTX = [[UITextView alloc]initWithFrame:CGRectMake(0.2062*CGRectW(self.initialBackIV), 0.1078*CGRectH(self.initialBackIV), 0.6014*CGRectW(self.initialBackIV), 0.4663*CGRectH(self.initialBackIV))];
        _detailFirstTX.text = [self.lotteryPoetryModel.cj2 stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        _detailFirstTX.textAlignment = NSTextAlignmentCenter;
        _detailFirstTX.font = MFont(14);
        _detailFirstTX.editable = NO;
        _detailFirstTX.backgroundColor = [UIColor clearColor];
        
    }
    return _detailFirstTX;
}

-(UITextView *)detailSecondTX{
    if (!_detailSecondTX) {
        _detailSecondTX = [[UITextView alloc]initWithFrame:CGRectMake(0.1512*CGRectW(self.initialBackIV), 0.6173*CGRectH(self.initialBackIV), 0.6976*CGRectW(self.initialBackIV), 0.2615*CGRectH(self.initialBackIV))];
        _detailSecondTX.text = [self.lotteryPoetryModel.xj stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        _detailSecondTX.textAlignment = NSTextAlignmentCenter;
        _detailSecondTX.font = MFont(14);
        _detailSecondTX.editable = NO;
        _detailSecondTX.backgroundColor = [UIColor clearColor];
    }
    return _detailSecondTX;
}

-(UIButton *)backToMainBtn{
    if (!_backToMainBtn) {
        _backToMainBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectX(self.initialBackIV), CGRectYH(self.initialBackIV)+0.0458*CGRectH(self.initialBackIV), 0.39375*Screen_width, 0.0834*CGRectH(self.initialBackIV))];
        [_backToMainBtn setBackgroundImage:MImage(@"xj_fh") forState:UIControlStateNormal];
        [_backToMainBtn addTarget:self action:@selector(clickBackToMainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToMainBtn;
}

-(UIButton *)pjBtn{
    if (!_pjBtn) {
        _pjBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.6117*CGRectW(self.initialBackIV), CGRectY(self.backToMainBtn), CGRectW(self.backToMainBtn), CGRectH(self.backToMainBtn))];
        [_pjBtn setBackgroundImage:MImage(@"xj_pj") forState:UIControlStateNormal];
        [_pjBtn addTarget:self action:@selector(clickPjBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pjBtn;
}


-(void)clickBackToMainBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)clickPjBtn{
    MYLog(@"破解之法");
    PjView *pjView = [[PjView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    pjView.delegate = self;
    [self.view addSubview:pjView];
}

#pragma mark - PjViewDelegate
-(void)clickBtnToPjZcVC{
    PjZcViewController *pjZcVC = [[PjZcViewController alloc]initWithTitle:@"招财秘方" image:nil];
    pjZcVC.lotteryPoetryModel = self.lotteryPoetryModel;
#warning 破解方法需要用户购买，接口缺失
    [self.navigationController pushViewController:pjZcVC animated:YES];

}


@end
