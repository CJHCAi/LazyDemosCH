//
//  InitialLotteryPoetryViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/18.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "InitialLotteryPoetryViewController.h"
#import "DetailLotteryPoetryViewController.h"

@interface InitialLotteryPoetryViewController()
/** 背景图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 初解背景图*/
@property (nonatomic, strong) UIImageView *initialBackIV;
/** 签号标签*/
@property (nonatomic, strong) UILabel *qhLB;
/** 初解标签*/
@property (nonatomic, strong) UILabel *cjLB;
/** 详细解签标签*/
@property (nonatomic, strong) UIButton *infoBtn;
@end

@implementation InitialLotteryPoetryViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    
}

#pragma mark - 视图初始化
-(void)initUI{
    [self.view addSubview:self.backIV];
    [self.backIV addSubview:self.initialBackIV];
    [self.initialBackIV addSubview:self.qhLB];
    [self.initialBackIV addSubview:self.cjLB];
    //初解签文
    NSString *str = [self.lotteryPoetryModel.cj1 stringByReplacingOccurrencesOfString:@"【批示】" withString:@""];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"," withString:@" "];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSArray *strArr = [str2 componentsSeparatedByString:@"\\n"];
    MYLog(@"%@",strArr);
    
    for (int i = 0; i < 3 ; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.1065*CGRectW(self.initialBackIV)+0.1787*CGRectW(self.initialBackIV)*(2-i), 0.1279*CGRectH(self.initialBackIV), 0.1787*CGRectW(self.initialBackIV), 0.7869*CGRectH(self.initialBackIV))];
        label.text = [NSString verticalStringWith:strArr[i]];
        label.font = MFont(15);
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [self.initialBackIV addSubview:label];
    }
    
    [self.backIV addSubview:self.infoBtn];
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
        _initialBackIV.image = MImage(@"cq_bg_ct");
        
    }
    return _initialBackIV;
}

-(UILabel *)qhLB{
    if (!_qhLB) {
        _qhLB = [[UILabel alloc]initWithFrame:CGRectMake(0.7251*CGRectW(self.initialBackIV), 0.1752*CGRectH(self.initialBackIV), 0.0962*CGRectW(self.initialBackIV), 0.3046*CGRectH(self.initialBackIV))];
        _qhLB.text = [NSString verticalStringWith:self.lotteryPoetryModel.qh];
        _qhLB.font = BFont(18);
        _qhLB.numberOfLines = 0;
    }
    return _qhLB;
}

-(UILabel *)cjLB{
    if (!_cjLB) {
        _cjLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(self.qhLB), CGRectYH(self.qhLB)+10, CGRectW(self.qhLB), 50)];
        _cjLB.text = @"初\n解";
        _cjLB.numberOfLines = 2;
        _cjLB.font = BFont(18);
    }
    return _cjLB;
}

-(UIButton *)infoBtn{
    if (!_infoBtn) {
        _infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.31875*Screen_width, CGRectYH(self.initialBackIV)+0.0458*CGRectH(self.initialBackIV), 0.39375*Screen_width, 0.0834*CGRectH(self.initialBackIV))];
        [_infoBtn setBackgroundImage:MImage(@"cq_btn") forState:UIControlStateNormal];
        _infoBtn.userInteractionEnabled = YES;
        [_infoBtn addTarget:self action:@selector(clickInfoBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoBtn;
}

-(void)clickInfoBtn{
    MYLog(@"详细解签");
    DetailLotteryPoetryViewController *detailVC = [[DetailLotteryPoetryViewController alloc]initWithTitle:@"详解" image:nil];
    detailVC.lotteryPoetryModel = self.lotteryPoetryModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
